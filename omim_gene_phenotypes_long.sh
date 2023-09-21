GENE=$1

echo "# "$GENE
grep -w $GENE  resources/omim_gene_map.txt | cut -f 13 | sed 's/;/\n/g' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/(/_OMGHOLDER_/g' | sed 's/_OMGHOLD/\n/g' | grep '^[0-9]' | grep -v "}" | while read line; do bash omim_id_phenotypes.sh $line; done
