## load libraries

library(ggplot2)
library(gridExtra)

## load functions

# read in the tsv files containing the Bowtie2 index stats, and give each table a unique name based on the stem of the tsv file
import_idxstats <- function(stats_dir){
  #stats_dir : path to directory containing Bowtie2 index stats tsv files
  fnames <- list.files(path = stats_dir,
                       pattern = ".tsv",
                       full.names = TRUE) #get list of tsv files in directory
  stats_tables <- lapply(fnames, read.table, sep = "\t") #read in list of tsv files
  basenames <- lapply(fnames, basename) #get just file name
  base_stem <- lapply(basenames, strsplit, "[./]") #split on "." to get the stem of the file name
  names(stats_tables) <- sapply(base_stem, function(x) lapply(x, "[[", 1)) #assumes no other . in file name
  stats_tables
}

# merge the HyLiTE expression.txt file and Bowtie2 index stats tsvs for use in visualisation
merge_tables <- function(hylite_exp_file, bowtie_idxstats){
  #hylite_exp_file : HyLiTE expression.txt file which has been read in as a dataframe
  #bowtie_idxstats : named list of Bowtie2 index statistics data frames
  merged <- merge(x = hylite_exp_file, 
                  y = bowtie_idxstats,
                  by.x = "GENE",
                  by.y = "V1") #assumes HyLiTE was run on the same gene file as was used in the stringent mapping
  merged
}

## example

# read in the HyLiTE expression.txt file
HH_p_exp <- read.table("./files/HH_p_hylite.expression.txt", sep = "\t", header = TRUE)

# import the Bowtie2 index statistics
idx_tabs <- import_idxstats("./files/")

# merge the expression.txt file with each element of the list of index statistics
merged_tabs <- lapply(idx_tabs, merge_tables, hylite_exp_file = HH_p_exp)

# plotting each replicate and calculating correlation coefficients
ga1ga_cor <- round(cor(x=merged_tabs$G_a_rep1_clstr_db$G_arboreum.G_a_rep1, y=merged_tabs$G_a_rep1_clstr_db$V3), 2) # calculate correlation to 2 dp
ga1ga_plot <- ggplot(merged_tabs$G_a_rep1_clstr_db, aes(G_arboreum.G_a_rep1, V3)) + 
  geom_point(alpha = 0.3) + # 30% opacity
  xlab("HyLiTE") + ylab("Bowtie2") + ggtitle("G. arboreum (rep 1)") +
  scale_y_continuous(breaks = seq(0, 40000, by = 20000)) +
  geom_abline() + annotate(geom = "text", x = -Inf, y = Inf, hjust = -4, vjust = 5, label = paste0("r = ", ga1ga_cor)) +
  theme_bw() +
  theme(panel.background = element_rect(colour = "black", size = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title = element_text(face="bold"))

ga2ga_cor <- round(cor(x=merged_tabs$G_a_rep2_clstr_db$G_arboreum.G_a_rep2, y=merged_tabs$G_a_rep2_clstr_db$V3), 2)
ga2ga_plot <- ggplot(merged_tabs$G_a_rep2_clstr_db, aes(G_arboreum.G_a_rep2, V3)) + 
  geom_point(alpha = 0.3) + 
  xlab("HyLiTE") + ylab("Bowtie2") + ggtitle("G. arboreum (rep 2)") +
  scale_x_continuous(breaks = seq(0, 40000, by = 20000)) +
  geom_abline() + annotate(geom = "text", x = -Inf, y = Inf, hjust = -4, vjust = 5, label = paste0("r = ", ga2ga_cor)) +
  theme_bw() +
  theme(panel.background = element_rect(colour = "black", size = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title = element_text(face="bold"))

gr1ga_cor <- round(cor(x=merged_tabs$G_r_rep1_clstr_db$G_raimondii.G_r_rep1, y=merged_tabs$G_r_rep1_clstr_db$V3), 2)
gr1ga_plot <- ggplot(merged_tabs$G_r_rep1_clstr_db, aes(G_raimondii.G_r_rep1, V3)) + 
  geom_point(alpha = 0.3) + 
  xlab("HyLiTE") + ylab("Bowtie2") + ggtitle("G. raimondii (rep 1)") + 
  geom_abline() + annotate(geom = "text", x = -Inf, y = Inf, hjust = -4, vjust = 5, label = paste0("r = ", gr1ga_cor)) +
  theme_bw() +
  theme(panel.background = element_rect(colour = "black", size = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title = element_text(face="bold"))

gr2ga_cor <- round(cor(x=merged_tabs$G_r_rep2_clstr_db$G_raimondii.G_r_rep2, y=merged_tabs$G_r_rep2_clstr_db$V3), 2)
gr2ga_plot <- ggplot(merged_tabs$G_r_rep2_clstr_db, aes(G_raimondii.G_r_rep2, V3)) + 
  geom_point(alpha = 0.3) + 
  xlab("HyLiTE") + ylab("Bowtie2") + ggtitle("G. raimondii (rep 2)") + 
  geom_abline() + annotate(geom = "text", x = -Inf, y = Inf, hjust = -4, vjust = 5, label = paste0("r = ", gr2ga_cor)) +
  theme_bw() + 
  theme(panel.background = element_rect(colour = "black", size = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title = element_text(face="bold"))

gh1ga_cor <- round(cor(x=merged_tabs$G_HH_rep1_clstr_db$G_arboreum_x_raimondii.G_HH_rep1, y=merged_tabs$G_HH_rep1_clstr_db$V3), 2)
gh1ga_plot <- ggplot(merged_tabs$G_HH_rep1_clstr_db, aes(G_arboreum_x_raimondii.G_HH_rep1, V3)) + 
  geom_point(alpha = 0.3) + 
  xlab("HyLiTE") + ylab("Bowtie2") + ggtitle("Homoploid hybrid (rep 1)") + 
  geom_abline() + annotate(geom = "text", x = -Inf, y = Inf, hjust = -4, vjust = 5, label = paste0("r = ", gh1ga_cor)) +
  theme_bw() + 
  theme(panel.background = element_rect(colour = "black", size = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title = element_text(face="bold"))

gh2ga_cor <- round(cor(x=merged_tabs$G_HH_rep2_clstr_db$G_arboreum_x_raimondii.G_HH_rep2, y=merged_tabs$G_HH_rep2_clstr_db$V3), 2)
gh2ga_plot <- ggplot(merged_tabs$G_HH_rep2_clstr_db, aes(G_arboreum_x_raimondii.G_HH_rep2, V3)) + 
  geom_point(alpha = 0.3) + xlab("HyLiTE") + ylab("Bowtie2") + ggtitle("Homoploid hybrid (rep 2)") + 
  geom_abline() + annotate(geom = "text", x = -Inf, y = Inf, hjust = -4, vjust = 5, label = paste0("r = ", gh2ga_cor)) +
  theme_bw() + 
  theme(panel.background = element_rect(colour = "black", size = 0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title = element_text(face="bold"))

# arrange plots on grid
grid.arrange(ga1ga_plot, ga2ga_plot, gr1ga_plot, gr2ga_plot, gh1ga_plot, gh2ga_plot, nrow = 3)
