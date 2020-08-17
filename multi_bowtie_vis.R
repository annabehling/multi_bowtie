##load libraries

library(ggplot2)

## load functions

# read in the tsv files containing the Bowtie2 index stats, and give each table a unique name based on the stem of the tsv file
import_idxstats <- function(stats_dir){
  #stats_dir : path to directory containing Bowtie2 index stats tsv files
  fnames <- list.files(path = stats_dir,
                       pattern = ".tsv",
                       full.names = TRUE) #get list of tsv files in directory
  stats_tables <- lapply(fnames, read.table, sep = "\t") #read in list of tsv files
  basenames <- lapply(fnames, basename) #get just file name
  base_stem <- lapply(basenames, strsplit, "[./]") #split on '.' to get the stem of the file name
  names(stats_tables) <- lapply(base_stem, function(x) lapply(x, '[[', 1)) #assumes no other . in file name
  stats_tables
}

# merge the HyLiTE expression.txt file and bowtie2 index stats tsvs for use in visualisation
merge_tables <- function(hylite_exp_file, bowtie_idxstats){
  merged <- merge(x = hylite_exp_file, 
                  y = bowtie_idxstats,
                  by.x = "GENE",
                  by.y = "V1") #assumes hylite was run on the same gene file as was used in the stringent mapping
  names(merged) <- paste0(bowtie_idxstats, '_m')
  merged
}

## example

# read in the HyLiTE expression.txt file
HH_p_exp <- read.table('HH_p_hylite.expression.txt', sep="\t", header=TRUE)

# import the Bowtie2 index statistics
idx_tabs <- import_idxstats('.')

# merge the expression.txt file with each element of the list of index statistics
merged_tabs <- lapply(idx_tabs, merge_tables, hylite_exp_file = HH_p_exp)


## plotting
