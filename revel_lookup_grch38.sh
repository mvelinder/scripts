CHR=$1
POS=$2

bcftools view -H /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/revel_v1.3_vcf_vep_grch38.vcf.gz $CHR:$POS 2>/dev/null

