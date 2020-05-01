#!/usr/bin/env python3

"""index_sam.py circumvents the inability of samtools 1.7 to give index statistics straight from sam files.
it automates the sequential use of samtools 'sort', 'index' and 'idxstats'
, to ultimately gain index stats from an input directory of sam files
usage : index_sam.py <sam_directory>
#sam_directory : directory containing the sam files to be sorted and indexed"""

import sys
import argparse
import os
import subprocess

def sam_files(sam_directory):
	"""takes a directory of sam files and outputs a list of sam files"""
	#sam_directory : directory containing the sam files
	sam_files = []
	for file in os.listdir(sam_directory):
		if file.endswith('.sam'):
			sam_files.append(file)
	if len(sam_files) == 0:
		raise ValueError("No files with ending '.sam' found in dir")
	return(sam_files)

def bam_names(sam_directory):
	"""takes a directory of sam files and outputs a list of bam file names"""
	#sam_directory : directory containing the sam files
	bam_files = []
	for file in sam_files(sam_directory):
		bam_files.append((file.split('.')[0]) + '.bam')
	return(bam_files)

def tsv_names(sam_directory):
	"""takes a directory of sam files and outputs a list of tsv file names"""
	#sam_directory : directory containing the sam files
	tsv_files = []
	for file in sam_files(sam_directory):
		tsv_files.append((file.split('.')[0]) + '.tsv')
	return(tsv_files)

if __name__ == '__main__': 
	
	parser = argparse.ArgumentParser() 
	parser.add_argument("sam_directory", help="path to directory containing sam files (str)")
	args = parser.parse_args()

	sam = sam_files(args.sam_directory)
	bam = bam_names(args.sam_directory)
	tsv = tsv_names(args.sam_directory)
	loop_index = 0
	for sam_value in sam:
		subprocess.call(['samtools', 'sort', sam[loop_index], '-o', bam[loop_index]]) #-o writes sorted output to file not stdout
		print('Created file called {}'.format(bam[loop_index]))
		subprocess.call(['samtools', 'index', bam[loop_index]])
		print('Created index file called {}.bai'.format(bam[loop_index]))
		subprocess.call(['samtools', 'idxstats', bam[loop_index]], stdout=open(tsv[loop_index], 'w'))
		print('Index stats for {} complete -- created index stats file called {}'.format(bam[loop_index], tsv[loop_index]))
		loop_index += 1

sys.exit(0)
