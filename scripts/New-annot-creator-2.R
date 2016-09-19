k = read.delim2('virparsed', col.names = c('id', 'Annotation', 'Group', 'Order', 'Family', 'Genus', 'Name+Host_info', 'NameThatRWantsMeToDefine'),
                stringsAsFactors = F, na.strings = "", quote = "", header = F, sep = '\t')
k$id <- substr(k$id,1,nchar(k$id)-1) #removing spacebars
k2 = read.table('overallpairscounted+blast', col.names = c("betw_sampl_count",
                                                          "vir_igc", "vir_id",
                                                          "identity", "align_length", "e_value", "bit-score", "AR_igc"),
                                                            stringsAsFactors = F, header = F)
k3 <- merge(k2, k, by.x = "vir_id", by.y = "id", all.x = T)
k3 <- k3[,-ncol(k3)]
k4 <- cbind(read.table('/data6/bio/metagenome_phages/AR-f1-ids', header = T, quote = "", sep = '\t'),
            read.table('/data6/bio/metagenome_phages/AR-f9-bgaro', header = T, quote = "", sep = '\t'),
            read.table('/data6/bio/metagenome_phages/AR-f15-arocategory', header = T, quote = "", sep = '\t'))
k5 <- merge(k3, k4, by.x = 'AR_igc', by.y = 'ORF_ID', all.x = T)
library(dplyr)
k5 <- select(k5, betw_sampl_count, vir_igc, vir_id, identity, align_length, e_value, bit.score, Annotation, Group, Order,
            Family, Genus, Name.Host_info, AR_igc, Best_Hit_ARO, AR0_category)
#ncol(k5)
#making taxonomic data pretty
#case if host info ended up in "order" column
k5[is.na(k5$Family) == T & is.na(k5$Order) == F, "Name.Host_info"] <- grep("phage",
                                                                           k5[is.na(k5$Family) == T & is.na(k5$Order) == F, "Order"],
                                                                           perl = TRUE, value = T)
#case if host info ended up in 'family' column
k5[is.na(k5$Genus) == T & is.na(k5$Family) == F, "Name.Host_info"] <- grep("phage",
                                                                      k5[is.na(k5$Genus) == T & is.na(k5$Family) == F, "Family"],
                                                                      perl = TRUE, value = T)
#case if host info ended up in 'genus' column
k5[is.na(k5$Name.Host_info) == T & is.na(k5$Genus) == F, "Name.Host_info"][grepl("phage",
                                                                            k5[is.na(k5$Name.Host_info) == T & is.na(k5$Genus) == F, "Genus"],perl = TRUE)] <- grep("phage", 
                                                                                                                                                                       k5[is.na(k5$Name.Host_info) == T & is.na(k5$Genus) == F, "Genus"],perl = TRUE, value = T)
#just for bacillus virus 1
k5[is.na(k5$Name.Host_info) == T & is.na(k5$Genus) == F, "Name.Host_info"][grepl("Bacillus",
                                                                            k5[is.na(k5$Name.Host_info) == T & is.na(k5$Genus) == F, "Genus"],perl = TRUE)] <- grep("Bacillus",
                                                                                                                                                                       k5[is.na(k5$Name.Host_info) == T & is.na(k5$Genus) == F, "Genus"],perl = TRUE, value = T)
k5$present_in_percent_samples <- k5$betw_sampl_count/760*100
write.table(k5[,-1], file = 'Vir_Ar_pairs_LCNL', sep = '\t', 
            col.names = T, row.names = F, quote = F)