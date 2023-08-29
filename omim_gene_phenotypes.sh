GENE=$1

echo ""# "$GENE
"
grep -w $GENE ~/scripts/resources/omim_gene_map.txt | cut -f 13 | sed 's/;/\n/g' | sed 's/,/\n/g' | sed 's/ //g' | sed 's/(/_OMGHOLDER_/g' | sed 's/_OMGHOLD/\n/g' | grep '^[0-9]' | grep -v "}" | while read line; do bash ~/scripts/omim_id_phenotypes.sh $line | sed '/^s*$/d' | grep -v ^[a-z] | grep -v ^"Caused by " | sed 's/(//g' | sed 's/)//g' | sed -e 's/{[^{}]*}//g' | sed 's/ ;//g' | awk '{$1=$1;print}' | perl -pe 's/\r?\n/, /'; printf "\n\n"; done
