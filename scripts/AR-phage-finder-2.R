ars <- read.table('/data6/bio/metagenome_phages/AR-genes-list-1008', header = T) #AR-genes list here
filenames <- readLines('/data6/bio/metagenome_phages/pairs/Lifilenames2') #filenames with viral-nonviral IGC gene pairs
for (i in filenames){
  print(i)
  out <- read.table(i)
  v_ar <- out[is.element(out$V2, ars$ORF_ID),]
  colnames(v_ar) <- c("Phage", "AR")
  write.table(v_ar, file = sprintf("%sar", substr(i, 1, (nchar(i)-22))), quote = F, sep = '\t', row.names = F, col.names = F)
}
