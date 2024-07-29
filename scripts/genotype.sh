#!/bin/bash
module load GATK/4.5.0.0
#for ii in {2..2}
#do
#gatk GenotypeGVCFs -R  /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa -V gendb://gatk_ped/chr${ii}_gdb -O finalvcf/chr${ii}.vcf.gz
#done

module load picard
java -jar $PICARDJARPATH/picard.jar GatherVcfs I=finalvcf/chr1.vcf.gz I=finalvcf/chr2.vcf.gz I=finalvcf/chr3.vcf.gz I=finalvcf/chr4.vcf.gz I=finalvcf/chr5.vcf.gz I=finalvcf/chr6.vcf.gz I=finalvcf/chr7.vcf.gz I=finalvcf/chr8.vcf.gz I=finalvcf/chr9.vcf.gz I=finalvcf/chr10.vcf.gz I=finalvcf/chr11.vcf.gz I=finalvcf/chr12.vcf.gz I=finalvcf/chr13.vcf.gz I=finalvcf/chr14.vcf.gz I=finalvcf/chr15.vcf.gz I=finalvcf/chr16.vcf.gz I=finalvcf/chr17.vcf.gz I=finalvcf/chr18.vcf.gz I=finalvcf/chr19.vcf.gz I=finalvcf/chr20.vcf.gz I=finalvcf/chr21.vcf.gz I=finalvcf/chr22.vcf.gz O=finalvcf/merged.vcf.gz

module load bcftools
tabix -f -p vcf finalvcf/merged.vcf.gz




