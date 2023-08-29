set -eou pipefail
VCF=$1
REF=~/scripts/resources/hg19.fa.gz

echo "Input: "$VCF""
echo "Running VEP..."

vep -i $VCF \
        -o $VCF.vep \
        --quiet \
        --fork 32 \
        --fields "Location,Allele,SYMBOL,IMPACT,Consequence,Protein_position,Amino_acids,CSN,Existing_variation,IND,ZYG,REVEL,MutScore,CCR,ClinVar,Z-score" \
        --cache \
        --dir_cache ~/.vep \
        --dir_plugins ~/.vep/Plugins \
        --assembly GRCh37 \
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
	--plugin REVEL,~/scripts/resources/revel_grch37_new_tabbed.tsv.gz \
        --custom ~/scripts/resources/ccrs.autosomes.v2.20180420.bed.gz.coords.bed.for.vep.bed.gz,CCR,bed,overlap,0 \
        --custom ~/scripts/resources/mutscore-v1.0-hg19.vep.vcf.gz,MutScore,vcf,exact,0,MutScore \
	--custom ~/scripts/resources/clinvar.grch37.vcf.gz,ClinVar,vcf,exact,0 \
        --custom ~/scripts/resources/gnomad.v2.1.1.lof_metrics.by_gene.mis_z.bed.gz,Z-score,bed,overlap,0

echo "Done"
