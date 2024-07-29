#!/bin/bash

#  AplasticPipeline.sh
#  
#
#  Created by Shouguo Gao (NIH/NHLBI) [E] on 9/1/23.
#  Edited by Jerry Sheng for practice 

####/gatk/gatk-package-4.3.0.0-local.jar

module load samtools
module load picard
module load GATK/4.5.0.0
module load bwa/0.7.17
module load bedtools

readarray -t lines < "filesTMT"

for line in {3..6}; 
do
echo "${lines[$line]}"

gunzip -c /data/gaos2/2022H0150SAAProject/SAAWES/original_japan_WES_bamfile/fastq_files/${lines[$line]}_r1.fq.gz > ${lines[$line]}_r1.fq
gunzip -c /data/gaos2/2022H0150SAAProject/SAAWES/original_japan_WES_bamfile/fastq_files/${lines[$line]}_r2.fq.gz > ${lines[$line]}_r2.fq

bwa mem -M -t 10 -p -R "@RG\tID:${lines[$line]}\tSM:${lines[$line]}\tPL:illumina\tPU:Lane1\tLB:exome" /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa ${lines[$line]}_r1.fq fastq_files/${lines[$line]}_r2.fq > sam/${lines[$line]}.aligned.sam

rm ${lines[$line]}_r1.fq
rm ${lines[$line]}_r2.fq

## 1. SortSam
# This tool sorts the input SAM or BAM file by coordinate, queryname (QNAME), or some other property of the SAM record.
# The SortOrder of a SAM/BAM file is found in the SAM file header tag @HD in the field labeled SO.

gatk SortSam -I sam/${lines[$line]}.aligned.sam -O sam/${lines[$line]}.sorted.sam -SO coordinate

## 2. SamFormatConverter
# Convert a BAM file to a SAM file, or SAM to BAM. Input and output formats are determined by file extension.

gatk SamFormatConverter -I sam/${lines[$line]}.sorted.sam -O bam/${lines[$line]}.sorted.bam


## 3. MarkDuplicates
# This tool locates and tags duplicate reads in a BAM or SAM file, where duplicate reads are defined as originating from a single fragment of DNA.
# Duplicates can arise during sample preparation e.g. library construction using PCR.
# Duplicates not have a origen biological

gatk MarkDuplicates -I bam/${lines[$line]}.sorted.bam -O bam/${lines[$line]}.Dedup.bam -M ${lines[$line]}.metrics.txt

##  4. BuildBamIndex
# Generates a BAM index ".bai" file. 
# This tool creates an index file for the input BAM that allows fast look-up of data in a BAM file, like an index on a database. 

gatk BuildBamIndex -I bam/${lines[$line]}.Dedup.bam -O bam/${lines[$line]}.Dedup.bai


## 5. BaseRecalibrator
# First pass of the base quality score recalibration. Generates a recalibration table based on various covariates and after applied in final bam
gatk BaseRecalibrator -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa -I bam/${lines[$line]}.Dedup.bam -O bam/${lines[$line]}.recal.data.table --known-sites /fdb/GATK_resource_bundle/hg19/dbsnp_138.hg19.vcf.gz


## 6. ApplyBQSR
# Apply base quality score recalibration
gatk ApplyBQSR -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa -I bam/${lines[$line]}.Dedup.bam --bqsr-recal-file bam/${lines[$line]}.recal.data.table -O bam/${lines[$line]}.recal.reads.bam




## 7.Call Mutation with Mutect2
#gatk Mutect2 -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa -I /data/shengj2/bam/${lines[$line]}.recal.reads.bam --disable-read-filter MateOnSameContigOrNoMappedMateReadFilter -O /data/shengj2/vcf/${lines[$line]}.vcf

##8 call genotypes and get gvcfs #repeat this step for each sample
gatk HaplotypeCaller -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa -I bam/${lines[$line]}.recal.reads.bam -ERC GVCF -O vcf/${lines[$line]}.HaplotypeCaller.g.vcf -ploidy 2


##9. separate snps and indels
gatk --java-options -Xmx4G SelectVariants -V vcf/${lines[$line]}.HaplotypeCaller.g.vcf -select-type SNP -O vcf/snp/${lines[$line]}.snp.g.vcf
gatk --java-options -Xmx4G SelectVariants -V vcf/${lines[$line]}.HaplotypeCaller.g.vcf -select-type INDEL -O vcf/indel/${lines[$line]}.indel.g.vcf

done


##10a. hard filtering
#snp
#gatk --java-options -Xmx4G VariantFiltration -V /data/shengj2/vcf/snp/${lines[$line]}.snp.vcf -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "SOR > 3.0" --filter-name "SOR3" -filter "FS > 60.0" --filter-name "FS60" --filter-expression "MQ < 40.0" --filter-name "MQ40" -#filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" -O /data/shengj2/vcf/snp/${lines[$line]}.filtered.snp.vcf
#indel
#gatk --java-options -Xmx4G VariantFiltration -V /data/shengj2/vcf/indel/${lines[$line]}.indel.vcf -filter "QD < 2.0" --filter-name "QD2" -filter "QUAL < 30.0" --filter-name "QUAL30" -filter "FS > 200.0" --filter-name "FS200" -filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" -O /data/shengj2/vcf/indel/${lines[$line]}.filtered.indel.vcf
