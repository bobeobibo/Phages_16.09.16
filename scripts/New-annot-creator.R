uniqpairs <- read.table('/data6/bio/metagenome_phages/pairs/overallpairscounted_Nielsen_Li_LeCh', stringsAsFactors = F, header = F)
#a collection of unique pairs that we have
virlist <- read.table('/data6/bio/metagenome_phages/IGC-viruses-2', stringsAsFactors = F, header = F)
#Chris's blast table, list of viruses
#The fields are: %identity, algn length, e-value
newtable <- data.frame(V1 = 0, V2 = 0, V3 = 0, V4 =0, V5 = 0, V6 = 0)
for (i in 1:length(uniqpairs$V2)){
  newtable <- rbind(newtable, virlist[which(virlist$V1 == uniqpairs$V2[i])[1],]) #[1] chooses best hits
}
newtable <- newtable[-1, ]
colnames(newtable) <- c("IGC_id", 'vir_id', 'identity', 'align_length', "e_value", "bit-score")
colnames(uniqpairs) <- c("betw_sampl_count", "vir_igc", "AR_igc")
#newtable is our viral info, but yet not annotations.
newnewtable <- unique(merge(uniqpairs, newtable, by.x = 'vir_igc', by.y = 'IGC_id'))
library(stringr)
newnewtable$vir_id <- str_extract(newnewtable$vir_id, "[0-9, -]+")
newnewtable <- newnewtable[,c(2,1,4,5,6,7,8,3)]
write.table(newnewtable, '/data6/bio/metagenome_phages/pairs/overallpairscounted_Nielsen_Li-LeCh+blast', quote = F, sep = '\t', col.names = F, row.names = F)

