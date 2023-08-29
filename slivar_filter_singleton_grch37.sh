vcf=$1
maf=$2
js=~/scripts/resources/slivar-functions.js
gnomad=~/scripts/resources/gnomad.genomes.r2.1.1.sites.slivar.zip

slivar expr --vcf $vcf \
    --pass-only \
    --js $js \
    -g $gnomad \
    --info 'INFO.gnomad_popmax_af < '$maf' && variant.FILTER == "PASS" && variant.ALT[0] != "*"' \
	-o $vcf.slivar.maf.$maf.vcf.gz
