CHR=$1 # no chr prefix... despite being grch38
POS=$2

bcftools view -H https://home.chpc.utah.edu/~u1138933/ConSplice/scored_vcf/ConSpliceML.scored.snvs.hg38.vcf.gz $CHR:$POS
