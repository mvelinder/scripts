VCF=$1
FASTA=~/scripts/resources/hg19.fa.gz

bcftools norm -m - -w 10000 -f $FASTA $VCF -O z -o $VCF.norm.vcf.gz
