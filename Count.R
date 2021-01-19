#Count the number of reads for each gene
library(dplyr)
x=read.table("final_matrix.csv", sep=",", header=FALSE)
new_count = x %>%
  group_by(V3) %>%
  summarise(Frequency = sum(V5))

write.table(new_count, file="Sum_genes", sep="\t", quote=FALSE, row.names=FALSE)

