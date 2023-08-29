CHR=$1
POS=$2

bcftools view -H ~/scripts/resources/revel_v1.3_vcf_vep_grch37.vcf.gz $CHR:$POS 2>/dev/null
