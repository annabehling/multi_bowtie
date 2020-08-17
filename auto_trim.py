#!/usr/bin/env python3

import sys
import argparse
import os
import subprocess

def qual_fastq(filt_directory):
	"""takes a directory containing fastq files that have been quality filtered using the SolexaQA++ 'dynamictrim' function"""
	#fastq_directory : directory containing quality filtered fastq files (extension: '.fastq.trimmed')
	qual_fastqs = []
	for file in os.listdir(filt_directory):
		if file.endswith('.fastq.trimmed'):
			qual_fastqs.append(file)
	if len(qual_fastqs) == 0:
		raise ValueError("No files with ending '.fastq.trimmed' found in dir")
	return(qual_fastqs)

if __name__ == '__main__': 
	
	parser = argparse.ArgumentParser() #use argparse to handle command line arguments
	parser.add_argument("filt_directory", help="path to directory containing the quality filtered fastq files (str)")
	args = parser.parse_args()

	qual_fastqs = qual_fastq(args.filt_directory)
	loop_index = 0
	for file in qual_fastqs:
		subprocess.call(['SolexaQA++', 'lengthsort', qual_fastqs[loop_index], '-l', '50', '-d', '.'])
		print('Processed {}'.format(qual_fastqs[loop_index]) )
		loop_index += 1 #so that it will go to the next value in the list

sys.exit(0)