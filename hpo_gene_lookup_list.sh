GENE=$1

echo $GENE "
"
grep -w $GENE /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/phenotype_to_genes.txt | sed 's/ /_/g' | awk '{FS=OFS="\t"}{print $4,$2,$1}' | sort -u | cut -f 2 | perl -pe 's/\r?\n/, /' ; printf "\n"
