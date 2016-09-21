viruses <- read.table('/data6/bio/metagenome_phages/IGC-viruses-3', stringsAsFactors = F, quote = "", sep = '\t')
blasthits <- read.table('/data6/bio/metagenome_phages/blast_out/IGC-viruses-pep-swsprt-no-phage', stringsAsFactors = F, quote = "", sep = '\t')
colnames(blasthits) <- c('qseqid', 'sseqid', 'pident', 'qlen', 'slen', 'length', 'mismatch', 'bitscore', 'evalue', 'sscinames', 'stitle')
blasthits2 <- blasthits[,c(1,3,8,10,11)]
colnames(viruses) <- c("igc", 'gi', "ident", "len", 'Evalue', 'bit.score')
#corrected table is less than viruses table because we only look for "untrusty" genes
corrected_table <- merge(viruses, blasthits2, by.x = "igc", by.y = "qseqid")
untrusty<- corrected_table[corrected_table$bitscore > corrected_table$bit.score,]
trusty<- viruses[is.element(viruses$igc, untrusty$igc)==F,]
write.table(trusty, file = '/data6/bio/metagenome_phages/tempresults/Trusty-viruses', row.names = F, col.names = T, quote=F, sep = '\t')
retrons <- read.table('/data6/bio/metagenome_phages/blast_out/IGC-viruses-pep-swsprt-retrons', stringsAsFactors = F, quote = "", sep = '\t')
colnames(retrons) <- c('qseqid', 'sseqid', 'pident', 'qlen', 'slen', 'length', 'mismatch', 'bitscore', 'evalue', 'sscinames', 'stitle')
retrons2 <- retrons[,c(1,3,8,10,11)]
corrected_table2 <- merge(viruses, retrons2, by.x = "igc", by.y = "qseqid")
actual_retrons <- corrected_table2[corrected_table2$bitscore > corrected_table2$bit.score,]
write.table(actual_retrons, file = '/data6/bio/metagenome_phages/tempresults/Some-retrons', row.names = F, col.names = T, quote=F, sep = '\t')
