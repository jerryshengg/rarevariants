#!/bin/bash

# Jerry Sheng
# Variant Filtration 

module load samtools
module load picard
module load GATK
module load bwa/0.7.17
module load bedtools

ref = "/fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa"

# Filter SNPs

gatk VariantFiltration \
	-R {ref} \
	-V finalvcf/filtering/SNP.recalibrated_99.9.vcf.gz \
	-O finalvcf/filtering/SNP.recalibrated_99.9.filtering.vcf.gz \
	--filter-name "QD_filter" --filter-expression "QD < 2.0" \
	--filter-name "FS_filter" --filter-expression "FS > 60.0" \
	--filter-name "MQ_filter" --filter-expression "MQ < 40.0" \
	--filter-name "SOR_filter" --filter-expression "SOR > 3.0" \
	--filter-name "MQRankSum_filter" --filter-expression "MQRankSum < -12.5" \
	--filter-name "ReadPosRankSum_filter" --filter-expression "ReadPosRankSum < -8.0" \
	--genotype-filter-name "DP_filter" \
	--genotype-filter-expression "DP < 10" \
	--genotype-filter-name "GQ_filter" --genotype-filter-expression "GQ < 10" 

# Filter INDELS
gatk --java-options "-Xmx4G" VariantFiltration \
	-R {ref} \
	-V finalvcf/filtering/indel.SNP.recalibrated_99.9.vcf.gz \
	-O finalvcf/filtering/indel.SNP.recalibrated_99.9.filtering.vcf.gz \
	--filter-name "QD_filter" --filter-expression "QD < 2.0" \
	--filter-name "FS_filter" --filter-expression "FS > 200.0" \
	--filter-name "SOR_filter" --filter-expression "SOR > 10.0" \
   	--filter-name "ReadPosRankSum_filter" --filter-expression "ReadPosRankSum < -20.0" \
	--genotype-filter-name "DP_filter" \
	--genotype-filter-expression "DP < 10" \
	--genotype-filter-name "GQ_filter" --genotype-filter-expression "GQ < 10"

