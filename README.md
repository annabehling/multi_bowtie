# multi_bowtie
Allopolyploid species are formed from mating between species that also causes in an increase in the chromosomal complement of the resulting hybrid offspring. Homoploid hybrid species also form from interspecific mating, but inherit the same number of chromosomes as their parental species.

[HyLiTE](https://hylite.sourceforge.io/index.html) is a program capable of parental origin to allopolyploid and homoploid hybrid high-throughput RNA-seq reads, through the implementation of [Bowtie 2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml). Usage of HyLiTE is significantly less frequent and widespread than Bowtie, thus, to validate HyLiTE data, one can generate read count matrices in Bowtie 2 and compare these to the read count matrices generated for the same data by HyLiTE.

## Description
Given the natural variability in gene expression between organisms of the same species, transcriptomic analyses are best performed using biological replicates for each constituent member of the study system.

The scripts `multi_bowtie.py` and `index_sam.py` were written in python, for successive use to automate the processing of a directory of fastq files.
