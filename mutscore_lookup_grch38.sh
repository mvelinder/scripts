CHR=$1
POS=$2

bcftools view -H /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/mutscore-v1.0-hg38.vep.vcf.gz $CHR:$POS | cut -f 1,2,4,5,8 | sed 's/MutScore=//g'
