#run in nohup

FILENAME=$1
IGCpepPATH=/data7a/bio/jsub/references/IGC/IGC.pep
OUTFILE=$2
for i in `cat $FILENAME`
do
	grep -A 1 $i $IGCpepPATH >> $OUTFILE
done
