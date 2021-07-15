## load function

igv_picker <- function(exp_file, readsum_file){
  #exp_file : path to a HyLiTE expression.txt file
  #readsum_file : path to a HyLiTE read.summary.txt file
  
  exp_tab <- read.table(exp_file, sep = "\t", header = TRUE) #read in the expression.txt file
  readsum_tab <- read.table(readsum_file, sep = "\t", header = TRUE) #read in the read.summary.txt file
  readsum_tab$P1_reads <- readsum_tab[, 4] + readsum_tab[, 5] #make a new column with P1 + (P1+N) reads
  readsum_tab$P2_reads <- readsum_tab[, 2] + readsum_tab[, 3] #make a new column with P2 + (P2+N) reads
  
  red_exp_tab <- exp_tab[ ,c(1, 4)] #give only the gene and HH rep1 columns from the expression table
  red_readsum_tab <- readsum_tab[ ,c(1, 10, 11)] #give only the gene and parental columns from the read summary table
  merged_tab <- merge(red_exp_tab, red_readsum_tab, by="GENE") #merge the reduced expression table with the read summary table
  merged_tab$P_total <- merged_tab[ ,3] + merged_tab[ ,4] #make a new column with total reads mapped to both parents
  merged_tab$P1_prop <- (merged_tab[ ,3]/merged_tab$P_total)*100 #make a new column with relative proportion of P1 reads
  
  candidate_genes <- merged_tab[(merged_tab[ ,2] >= 150) & (merged_tab[ ,2] <= 200), ] #give only genes with 150-200 reads mapped to HH
  candidate_genes <- candidate_genes[candidate_genes$P_total >= 100, ] #give only genes with at least 100 reads assigned to parents
  
  return(candidate_genes)
}

## example

candidates <- igv_picker("./example_outfiles/HH_p_hylite.expression.txt", "./example_outfiles/HH_p_hylite.G_arboreum_x_raimondii.G_HH_rep1.read.summary.txt") #get all candidates

high_genes <- candidates[candidates$P1_prop >= 75, ] #get the high expression candidate genes
mid_genes <- candidates[(candidates$P1_prop) >= 45 & (candidates$P1_prop <= 55), ] #get the mid expression candidate genes
low_genes <- candidates[candidates$P1_prop <= 25, ] #get the low expression candidate genes

