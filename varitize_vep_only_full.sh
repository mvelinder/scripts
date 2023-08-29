#! /bin/bash
#set -eou pipefail

# user-defined variables
VEP=$1

# other variables
GENCC=~/scripts/resources/gencc-submissions.tsv
HPO_FILE=~/scripts/resources/HPO_phenotype_to_genes.txt
UNI_FILE=~/scripts/resources/uniprot_gene_descriptions.tsv
PATHWAY_FILE=~/scripts/resources/PathwayCommons12.All.hgnc.txt
PLI_FILE=~/scripts/resources/gnomad.v2.1.1.lof_metrics.by_gene.txt
TF_FILE=~/scripts/resources/tf-target-infomation.txt
VEP_IMPACTFUL=$VEP.impactful.tsv
GENCC_ALL=$VEP_IMPACTFUL.gencc.all.txt
GENCC_AD_HET=$VEP_IMPACTFUL.gencc.ad.het.txt
GENCC_AD_HET_VAR=$VEP_IMPACTFUL.gencc.ad.het.variants.txt
GENCC_AR_HOM=$VEP_IMPACTFUL.gencc.ar.hom.txt
GENCC_AR_HOM_VAR=$VEP_IMPACTFUL.gencc.ar.hom.variants.txt
HPO=$VEP_IMPACTFUL.hpo.txt
OMIM=$VEP_IMPACTFUL.omim.txt
UNI=$VEP_IMPACTFUL.uniprot.txt
PATHWAYS=$VEP_IMPACTFUL.pathwaycommons.txt
INTERACT=$VEP_IMPACTFUL.interactors.txt
GENE_PLI=$VEP_IMPACTFUL.gene.pli.txt
GENE_Z_SCORE=$VEP_IMPACTFUL.gene.z.score.txt
TFTARGETS=$VEP.tf.targets.tsv
TFTARGETED=$VEP.tf.targeted.tsv

# get impactful variants as tsv
echo "Prioritizing impactful variants from slivar..."
grep -v ^## $VEP | head -n 1 > $VEP_IMPACTFUL
time grep -v ^# $VEP | awk '{FS=OFS="\t"} $4 == "MODERATE" || $4 == "HIGH" || $18 ~ "splice_region"' | sort -u >> $VEP_IMPACTFUL

# get gene:disease associations for impactful variants according to gencc
echo "Prioritizing impactful variants using GENCC..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$3 == line' $GENCC; done > $GENCC_ALL

# get gene:disease associations for impactful het variants with dominant disease moi
tail -n+2 $VEP_IMPACTFUL | awk '$10 == "HET"' | cut -f 3 | sort -u | while read line; do awk -v line=$line '$3 == line' $GENCC; done | grep -i dominant | cut -f 3,5,11 | sort -u > $GENCC_AD_HET

# get variants from above into their own file
tail -n+2 $VEP_IMPACTFUL | awk '$10 == "HET"' | cut -f 3 | sort -u | while read line; do awk -v line=$line '$3 == line' $GENCC; done | grep -i dominant | cut -f 3 | while read line; do awk -v line=$line '$3 == line' $VEP_IMPACTFUL; done > $GENCC_AD_HET_VAR

# get gene:disease association for impactful hom variants with recessive disease moi
tail -n+2 $VEP_IMPACTFUL | awk '$10 == "HOM"' | cut -f 3 | sort -u | while read line; do awk -v line=$line '$3 == line' $GENCC; done | grep -i recessive | cut -f 3,5,11 | sort -u > $GENCC_AR_HOM

# get variants from above into their own file
tail -n+2 $VEP_IMPACTFUL | awk '$10 == "HOM"' | cut -f 3 | sort -u | while read line; do awk -v line=$line '$3 == line' $GENCC; done | grep -i recessive | cut -f 3 | while read line; do awk -v line=$line '$3 == line' $VEP_IMPACTFUL; done > $GENCC_AR_HOM_VAR

# get all gene:HPO associations for impactful variants
echo "Prioritizing impactful variants using HPO..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$1 == line' $HPO_FILE; done | sort -u > $HPO

# get all gene descriptions from UniProt
echo "Getting gene descriptions from UniProt"
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do grep -w $line $UNI_FILE; done | sort -u > $UNI

# get all gene:phenotypes from OMIM for impactful variants
echo "Prioritizing impactful variants using OMIM..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do bash ~/scripts/omim_gene_phenotypes.sh $line; done > $OMIM

# get all gene:pathway information from pathwaycommons
echo "Getting gene:pathway information..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$1 == line && $6 != ""' $PATHWAY_FILE | cut -f 1,2,6 | sort -u; done > $PATHWAYS

# get all protein:protein interactions
echo "Getting protein:protein interaction information..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$1 == line' $PATHWAY_FILE | cut -f 1-3 | sort -u; done > $INTERACT

# get tf targets and targeted
echo "Getting TF targets and targeted by..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$1 == line' $TF_FILE; done > $TFTARGETS
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$2 == line' $TF_FILE; done > $TFTARGETED

# get all impactful gene pLIs
echo "Getting impactful gene pLIs..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$1 == line' $PLI_FILE | cut -f 1,21 | sort -u; done > $GENE_PLI

# get all impactful gene z-scores
echo "Getting impactful gene z-scores..."
time tail -n+2 $VEP_IMPACTFUL | cut -f 3 | sort -u | while read line; do awk -v line=$line '$1 == line' $PLI_FILE | cut -f 1,33 | sort -u; done > $GENE_Z_SCORE

echo "Done!"
