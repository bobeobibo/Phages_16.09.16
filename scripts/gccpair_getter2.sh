#!/bin/bash
RES_DIR=Li2014
VIRALDIR=/data6/bio/metagenome_phages/pairs/pairs-with-viruses/$RES_DIR
NONVIRALDIR=/data6/bio/metagenome_phages/pairs/pairs-with-non-viruses/$RES_DIR
RES_RAW_DIR=/data7a/bio/reads/ext_data/global_resistome/MetaHIT/Li_2014/merged_reads  
PYTHONDIR=/data6/bio/metagenome_phages/scripts/python
OUTDIR=/data6/bio/metagenome_phages/pairs/$RES_DIR
basenamess=/data6/bio/metagenome_phages/pairs/Libasenames

for i in `ls $RES_RAW_DIR | grep "pair.1"`
do
	echo $(basename $i .pair.1.fq.gz) >> $basenamess
done
#^ unique basenames to use in the followinng script
#
for i in `cat $basenamess`
do
	# in case left is viral and right is not
	python $PYTHONDIR/get_contig_contig_pairs.py $VIRALDIR/$i.pair.1.pairs.viral $NONVIRALDIR/$i.pair.2.pairs.non-viral $OUTDIR/$i.vir-nvir.pairs_output1 > $OUTDIR/$i.vir-nvir.gccp_log
	# in case right is viral and left is not
	python $PYTHONDIR/get_contig_contig_pairs.py $VIRALDIR/$i.pair.2.pairs.viral $NONVIRALDIR/$i.pair.1.pairs.non-viral $OUTDIR/$i.vir-nvir.pairs_output2 >> $OUTDIR/$i.vir-nvir.gccp_log
	cat $OUTDIR/$i.vir-nvir.pairs_output1 $OUTDIR/$i.vir-nvir.pairs_output2 > $OUTDIR/$i.vir-nvir.pairs_output_both
	rm $OUTDIR/$i.vir-nvir.pairs_output1
	rm $OUTDIR/$i.vir-nvir.pairs_output2
done

