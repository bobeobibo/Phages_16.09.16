STEP 1. Mapping MetaHIT reads to IGC database
%mapping MetaHIT reads to IGC database
qsub bowtie_map.sh x00 #x00 means file with reads filenames

STEP 2. Choosing "viral" and "non-viral" reads, checking if some of them were pairs, which possibly means transduction event
%detecting which of the mapped reads are "viral" and which are not. We use filtered table of Chris's 10.08 blast hits

ls > ../Nielsenfilenames #creating list of files with mapped reads
nohup python viral_reads_extractor3.py& 

%extracting paired reads from "viral-nonviral" pairs
nohup bash gccpair_getter.sh&

STEP 3. Choosing pairs containing AR-genes
%creating usable AR-genes list from Chris's latest rgi annotation
cut -f1 all.rgi.out.tsv.txt | awk '{ print $1}' >  /data6/bio/metagenome_phages/AR-genes-list-1008

%list of transduction filenames for R
ls | grep "_both" > ../Lifilenames  
%creating tables with vir-ar pairs
AR-phage-finder-2.R

STEP 4. Creating annotation table
%sort each table uniquely and count in-sample frequencies
for i in *.vir-ar; do sort $i | uniq -c | sort -nk1 > $i.counted; done

%concatenate all tables and count between-sample frequencies
cat *.counted | awk '{ print $2, '\t', $3}' | sort | uniq -c | sort -nk1 > overallpairscounted

%take all valuable POG BLAST information
cut -f1,2,3,11 all.IGC.pep.fa.blast.out.tab.filtered > /data6/bio/metagenome_phages/IGC-viruses-2

%add blasthit info to pairs table, but not yet annotation. creates file "overallpairscounted+blast"
New-annot-creator.R

%selecting lines that we need from pogs.txt
for i in `cut -f3 overallpairscounted+blast`; do grep $i /data7a/bio/metagenome_phages/IGC_Chris_data/Ar_phage_metagenomics_analyes/pogs.txt >> grepforparse; done

%parsing through pogs.txt
python annotationsplitter > ../../pairs/grepforparse.splitted
cut -f3 grepforparse.splitted > viridannotation
python annotationf3parser > /data6/bio/metagenome_phages/pairs/viridannotationparsed
cut -f4,5,6,7,8 grepforparse.splitted > virtaxdata
python annotationf45678parser > /data6/bio/metagenome_phages/pairs/virtaxdataparsed
paste -d '' viridannotationparsed virtaxdataparsed | sort -u > virparsed

%Splitting AR-genes annotations table into useful pieces
cut -f1 all.rgi.out.tsv.txt > /data6/bio/metagenome_phages/AR-f1-ids
cut -f9 all.rgi.out.tsv.txt > /data6/bio/metagenome_phages/AR-f9-bgaro
cut -f15 all.rgi.out.tsv.txt > /data6/bio/metagenome_phages/AR-f15-arocategory

%annotation table itself
New-annot-creator-2.R

