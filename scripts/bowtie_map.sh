#!/bin/sh
#$ -j y
#$ -S /bin/sh
#$ -pe make 10
#$ -q all.q
#$ -cwd

BWT_INDEX1=/data7a/bio/soft/MOCAT2/data/bowtie2/IGC.1
BWT_INDEX2=/data7a/bio/soft/MOCAT2/data/bowtie2/IGC.2
OUTDIR=/data6/bio/metagenome_phages


while read READS
do
	SHORT_NAME=$(basename $READS .fq.gz)
	bowtie2 -x $BWT_INDEX1 -U $READS -k 1 -p 10 --no-unal --sensitive-local --un $OUTDIR/temp/$SHORT_NAME.unmapped.fq --seed 50 -S $OUTDIR/temp/$SHORT_NAME.1.sam
	bowtie2 -x $BWT_INDEX2 -U $OUTDIR/temp/$SHORT_NAME.unmapped.fq -k 1 -p 10 --no-unal --sensitive-local --seed 50 -S $OUTDIR/temp/$SHORT_NAME.2.sam
	rm $OUTDIR/temp/$SHORT_NAME.unmapped.fq
	python $OUTDIR/scripts/python/get_read_contig_pairs.py $OUTDIR/temp/$SHORT_NAME.1.sam | sort > $OUTDIR/pairs/$SHORT_NAME.pairs
	python $OUTDIR/scripts/python/get_read_contig_pairs.py $OUTDIR/temp/$SHORT_NAME.2.sam | sort >> $OUTDIR/pairs/$SHORT_NAME.pairs
	gzip $OUTDIR/pairs/$SHORT_NAME.pairs
	rm $OUTDIR/temp/$SHORT_NAME.1.sam
	rm $OUTDIR/temp/$SHORT_NAME.2.sam
done < $1
