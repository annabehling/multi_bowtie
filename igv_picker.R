## load function

igv_picker <- function(exp_file, readsum_file){
  #exp_file : path to a HyLiTE expression.txt file
  #readsum_file : path to a HyLiTE read.summary.txt file
  
  exp_tab <- read.table(exp_file, sep = '\t', header = TRUE) #read in the expression.txt file
  readsum_tab <- read.table(readsum_file, sep = '\t', header = TRUE) #read in the read.summary.txt file
  
  red_exp_tab <- exp_tab[ ,c(1, 4)] #give only the gene and HH rep1 columns from the expression table
  red_readsum_tab <- readsum_tab[ ,c(1, 2, 4)] #give just the gene and parental columns (no +N) from the read summary table
  merged_tab <- merge(red_exp_tab, red_readsum_tab, by='GENE') #merge the reduced expression table with the read summary table
  merged_tab$p_reads <- merged_tab[ ,4] + merged_tab[ ,3] #make a new column with total reads mapped to both parents
  merged_tab$p1_prop <- (merged_tab[ ,4]/merged_tab$p_reads)*100 #make a new column with relative proportion of P1 reads
  
  candidate_genes <- merged_tab[(merged_tab[ ,2] >= 150) & (merged_tab[ ,2] <= 200), ] #give only genes with 150-200 reads mapped to HH
  candidate_genes <- candidate_genes[candidate_genes$p_reads >= 100, ] #give only genes with at least 100 reads assigned to parents
  
  return(candidate_genes)
}

## example

candidates <- igv_picker('HH_p_hylite.expression.txt', 'HH_p_hylite.G_arboreum_x_raimondii.G_HH_rep1.read.summary.txt') #get all candidates

high_genes <- candidates[candidates$p1_prop >= 75, ] #get the high expression candidate genes
mid_genes <- candidates[(candidates$p1_prop) >= 45 & (candidates$p1_prop <= 55), ] #get the mid expression candidate genes
low_genes <- candidates[candidates$p1_prop <= 25, ] #get the low expression candidate genes