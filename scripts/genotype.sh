#!/bin/bash

# Load necessary modules
module load GATK/4.5.0.0
module load picard
module load bcftools

# Define directories
GENOME_FA="/fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa"
GENDB_DIR="gatk_ped"
FINAL_VCF_DIR="finalvcf"
MERGED_VCF="${FINAL_VCF_DIR}/merged.vcf.gz"

# Genotype GVCFs (uncomment and adjust as needed)
for ii in {1..22}; do
    gatk GenotypeGVCFs -R "$GENOME_FA" -V gendb://"$GENDB_DIR"/chr${ii}_gdb -O "$FINAL_VCF_DIR"/chr${ii}.vcf.gz
done

# Gather VCF files
VCF_INPUTS=$(for i in {1..22}; do echo "I=${FINAL_VCF_DIR}/chr${i}.vcf.gz"; done)
java -jar $PICARDJARPATH/picard.jar GatherVcfs $VCF_INPUTS O="$MERGED_VCF"

# Index the merged VCF file
tabix -f -p vcf "$MERGED_VCF"
