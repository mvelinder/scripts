CRAM=$1
REF=$2
# /scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/Homo_sapiens.GRCh38.dna.toplevel.fa
# /scratch/ucgd/lustre-work/marth/u0691312/reference/ensembl/human_g1k_v37_decoy.fasta.gz
MODEL=$3 # WGS/WES/PacBio
THREADS=$4
BIN_VERSION=$5 # 1.5.0 (as of 8/24/2023) see https://github.com/google/deepvariant

# make tmp dir
mkdir intermediate_results

# pull image with bin version
singularity pull docker://google/deepvariant:"${BIN_VERSION}"

# run deepvariant
singularity run -B /usr/lib/locale/:/usr/lib/locale/ docker://google/deepvariant:${BIN_VERSION} /opt/deepvariant/bin/run_deepvariant \
	--model_type $MODEL \
	--ref $REF \
	--reads $CRAM \
	--intermediate_results_dir intermediate_results/ \
	--output_vcf $CRAM.vcf.gz \
	--output_gvcf $CRAM.gvcf.gz \
	--num_shards $THREADS
