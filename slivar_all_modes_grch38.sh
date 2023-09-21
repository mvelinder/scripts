#!/bin/bash
set -euxo pipefail

## set these variables
vcf=$1
ped=$2
fasta=resources/hg38.fa.gz
gnomad=resources/gnomad.genomes.v3.1.sites.slivar.zip
js=resources/slivar-functions.js
## end variables

# slivar all modes
slivar expr --vcf $vcf --ped $ped \
    --pass-only \
    --js $js \
    -g $gnomad \
    --info 'INFO.gnomad_popmax_af < 0.01 && variant.FILTER == "PASS" && variant.ALT[0] != "*"' \
    --family-expr 'denovo:fam.every(segregating_denovo) && INFO.gnomad_popmax_af < 0.001' \
    --family-expr 'x_denovo:(variant.CHROM == "X" || variant.CHROM == "chrX") && fam.every(segregating_denovo_x) && INFO.gnomad_popmax_af < 0.001' \
    --family-expr 'recessive:fam.every(segregating_recessive)' \
    --family-expr 'dominant:fam.every(segregating_dominant)' \
    -o $vcf.slivar.vcf.gz

slivar expr --vcf $vcf --ped $ped \
    --pass-only \
    --js $js \
    -g $gnomad \
    --family-expr 'denovo:fam.every(segregating_denovo) && INFO.gnomad_popmax_af < 0.001' \
    --trio 'comphet_side:comphet_side(kid, mom, dad) && INFO.gnomad_popmax_af < 0.005' \
    | slivar_static compound-hets -v /dev/stdin --skip NONE -s comphet_side -s denovo -p $ped -o $vcf.slivar.ch.vcf.gz

tabix $vcf.slivar.vcf.gz
tabix $vcf.slivar.ch.vcf.gz

bcftools concat -a -d none $vcf.slivar.vcf.gz $vcf.slivar.ch.vcf.gz -o $vcf.slivar.all.vcf.gz -O z

tabix $vcf.slivar.all.vcf.gz
