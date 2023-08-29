CHR=$1
POS=$2

bcftools view -H ~/scripts/resources/mutscore-v1.0-hg19.vep.vcf.gz $CHR:$POS | cut -f 1,2,4,5,8 | sed 's/MutScore=//g'
