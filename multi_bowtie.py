#!/usr/bin/env python3

"""bowtie_multi.py automates the bowtie2 command line for multiple runs using different fastq files
usage : bowtie_multi.py <bowtie_index> <fq_directory>
the script takes a directory of fastq files and the stem name of a bowtie2 index,
then, using subprocess it calls bowtie2 with the arguments generated from fastq_files() and sam_names()
#bowtie_index : bowtie2 index stem name, e.g. G_a_db
#fq_directory : directory containing the fastq files to be mapped"""

import sys
import argparse
import os
import subprocess

def fastq_files(fq_directory):
	"""takes a directory of fastq files and returns a list of fastq files"""
	#fq_directory : directory containing the fastq files to be mapped 	
	fq_files = []
	for file in os.listdir(fq_directory):
		#print(file)
		if file.endswith('.fastq.trimmed.single'): #fastq file format following SolexaQA dynamictrim and lengthsort
			fq_files.append(file)
	if len(fq_files) == 0:
		raise ValueError("No files with ending '.fastq.trimmed.single' found in dir")		
	return(fq_files)

def sam_names(fq_directory, bowtie_index):
	"""takes a directory of fastq files, then uses the stem names of the fastq files 
	and the bowtie_index (to differentiate sam files made from mapping against P1 / P2)
	to return a list of sam file names unique for each fastq file"""
	#fq_directory : directory containing the fastq files to be mapped 
	#bowtie_index : bowtie2 index stem name, e.g. G_a_db
	sam_files = []
	for file in fastq_files(fq_directory):
		sam_files.append((file.split('.')[0]) + '_' + bowtie_index + '.sam') #string manipulation with .split to get the stem name
	return(sam_files)


if __name__ == '__main__': 
	
	parser = argparse.ArgumentParser() #use argparse to handle command line arguments
	parser.add_argument("bowtie_index", help="bowtie2 index stem name (str)")
	parser.add_argument("fq_directory", help="path to directory containing the fastq files to be mapped (str)")
	args = parser.parse_args()

	fastq = fastq_files(args.fq_directory)
	sam = sam_names(args.fq_directory, args.bowtie_index)
	loop_index = 0
	for sam_value in sam:
		subprocess.call(['bowtie2', '--score-min C,0,0', '-x', args.bowtie_index, '-U', fastq[loop_index], '-S', sam[loop_index]]) #added in score min for 0 mismatches
		print('Created file called {}'.format(sam[loop_index]) )
		loop_index += 1 #so that it will go to the next value in the list

sys.exit(0)

