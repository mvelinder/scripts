set -eou pipefail
VCF=$1
REF=~/scripts/resources/hg38.fa.gz

echo "Input: "$VCF""
echo "Running VEP..."

vep -i $VCF \
        -o $VCF.vep \
        --quiet \
        --fork 32 \
        --fields "Location,Allele,SYMBOL,IMPACT,Consequence,Protein_position,Amino_acids,CSN,Existing_variation,IND,ZYG,REVEL,EVE_EVE,MutScore,CCR,ClinVar,Z-score" \
        --cache \
        --dir_cache ~/.vep \
        --dir_plugins ~/.vep/Plugins \
        --assembly GRCh38 \
        --force_overwrite \
        --individual all \
        --fasta $REF \
        --symbol \
        --biotype \
        --max_sv_size 5000 \
        --tab \
        --max_af \
        --no_stats \
	--plugin CSN \
	--plugin REVEL,~/scripts/resources/revel_grch38_new_tabbed.tsv.gz \
        --custom ~/scripts/resources/EVE.all.variants.chr.vcf.gz,EVE,vcf,exact,0,EVE \
        --custom ~/scripts/resources/mutscore-v1.0-hg38.vep.vcf.gz,MutScore,vcf,exact,0 \
	--custom ~/scripts/resources/clinvar.grch38.vcf.gz,ClinVar,vcf,exact,0 \
	--custom ~/scripts/resources/ccrs.autosomes.v2.20180420.bed.gz.hg38.liftover.bed.for.vep.uniq.bed.gz,CCR,bed,overlap,0 \
        --custom ~/scripts/resources/gnomad.v2.1.1.lof_metrics.by_gene.liftover.grch38.sorted.bed.gz,Z-score,bed,overlap,0

echo "Done"

