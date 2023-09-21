set -eou pipefail
VCF=$1
REF=/scratch/ucgd/lustre/work/u0691312/reference/ensembl/homo_sapiens/109_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz

echo "Input: "$VCF""
echo "Running VEP..."

vep -i $VCF \
        -o $VCF.vep \
        --quiet \
        --fork 48 \
        --fields "Location,Allele,SYMBOL,IMPACT,Consequence,Protein_position,Amino_acids,CSN,Existing_variation,IND,ZYG,REVEL,MutScore,CCR,ClinVar,Z-score,slivar_gnomad_popmax_af,slivar_gnomad_n_hets,slivar_gnomad_n_homalt" \
        --cache \
        --dir_cache /scratch/ucgd/lustre/work/u0691312/reference/ensembl/ \
        --dir_plugins /scratch/ucgd/lustre/work/u0691312/reference/ensembl/Plugins \
        --custom /scratch/ucgd/lustre/work/u0691312/reference/ccrs.autosomes.v2.20180420.bed.gz.coords.bed.for.vep.bed.gz,CCR,bed,overlap,0 \
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
	--plugin REVEL,/scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Plugins/new_tabbed_revel.tsv.gz \
        --custom /scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Plugins/mutscore-v1.0-hg19.vep.vcf.gz,MutScore,vcf,exact,0,MutScore \
	--custom /scratch/ucgd/lustre-work/marth/u0691312/reference/clinvar/clinvar.grch37.vcf.gz,ClinVar,vcf,exact,0 \
        --custom $VCF,slivar,vcf,exact,0,gnomad_n_hets \
        --custom $VCF,slivar,vcf,exact,0,gnomad_n_homalt \
        --custom $VCF,slivar,vcf,exact,0,gnomad_popmax_af \
        --custom /scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Plugins/gnomad.v2.1.1.lof_metrics.by_gene.mis_z.bed.gz,Z-score,bed,overlap,0

echo "Done"
