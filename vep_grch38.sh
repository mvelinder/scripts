set -eou pipefail
VCF=$1
REF=/scratch/ucgd/lustre/work/u0691312/reference/ensembl/Homo_sapiens.GRCh38.dna.toplevel.fa

echo "Input: "$VCF""
echo "Running VEP..."

vep -i $VCF \
        -o $VCF.vep \
        --quiet \
        --fork 48 \
        --fields "Location,Allele,SYMBOL,IMPACT,Consequence,Protein_position,Amino_acids,CSN,Existing_variation,IND,ZYG,REVEL,EVE_EVE,MutScore_MutScore,AlphaMissense_AlphaMissense,CCR,ClinVar,Z-score,slivar_gnomad_popmax_af,slivar_gnomad_n_hets,slivar_gnomad_n_homalt" \
        --cache \
        --dir_cache /scratch/ucgd/lustre/work/u0691312/reference/ensembl/ \
        --dir_plugins /scratch/ucgd/lustre/work/u0691312/reference/ensembl/Plugins \
        --custom /scratch/ucgd/lustre/work/u0691312/reference/ccrs.autosomes.v2.20180420.bed.gz.hg38.liftover.bed.for.vep.uniq.bed.gz,CCR,bed,overlap,0 \
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
	--plugin REVEL,/scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Plugins/new_tabbed_revel_grch38.tsv.gz \
	--plugin CSN \
        --custom /scratch/ucgd/lustre/work/u0691312/reference/EVE/vcf_files_missense_mutations/EVE.all.variants.chr.vcf.gz,EVE,vcf,exact,0,EVE \
        --custom /scratch/ucgd/lustre/work/u0691312/reference/mutscore-v1.0-hg38.vep.vcf.gz,MutScore,vcf,exact,0,MutScore \
	--custom /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/clinvar.grch38.chr.vcf.gz,ClinVar,vcf,exact,0,CLNDN%CLNSIG%CLNSIGCONF%RS%GENEINFO \
        --custom /scratch/ucgd/lustre-work/marth/u0691312/scripts/resources/AlphaMissense_hg38.vcf.gz,AlphaMissense,vcf,exact,0,AlphaMissense \
        --custom $VCF,slivar,vcf,exact,0,gnomad_n_hets \
        --custom $VCF,slivar,vcf,exact,0,gnomad_n_homalt \
        --custom $VCF,slivar,vcf,exact,0,gnomad_popmax_af \
        --custom /scratch/ucgd/lustre/work/u0691312/reference/ensembl/Plugins/gnomad.v2.1.1.lof_metrics.by_gene.liftover.grch38.sorted.bed.gz,Z-score,bed,overlap,0

echo "Done"


#        --plugin REVEL,/scratch/ucgd/lustre/work/u0691312/reference/ensembl/Plugins/revel_all_chromosomes_vep.tsv.gz.bed.grch38.liftover.bed.gz.vep.tsv.gz \
#        --custom /scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Plugins/clinvar.vcf.gz.bed.gz,ClinVar,bed,exact,0 \

#	--custom /scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Plugins/revel_v1.3_vcf_vep_grch38.vcf.gz,REVEL,vcf,exact,0 \
