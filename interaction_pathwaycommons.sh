GENE=$1

awk -v GENE=$GENE '$1 == GENE || $3 == GENE' /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/PathwayCommons12.All.hgnc.txt | uniq

