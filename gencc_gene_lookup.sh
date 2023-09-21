GENE=$1

grep -w $GENE /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/gencc-submissions-fixed.tsv | cut -f 3,5,9,1
