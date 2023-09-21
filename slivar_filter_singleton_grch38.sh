vcf=$1
maf=$2
gnomad=/scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/gnomad.genomes.v3.1.sites.slivar.zip
js=/scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/slivar-functions.js

slivar expr --vcf $vcf \
    --pass-only \
    --js $js \
    -g $gnomad \
    --info 'INFO.gnomad_popmax_af < '$maf' && variant.FILTER == "PASS" && variant.ALT[0] != "*"' \
    -o $vcf.slivar.maf.$maf.vcf.gz
