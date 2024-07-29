#! /bin/bash

module load GATK/4.5.0.0
gatk --java-options "-Xms4G -Xmx4G" VariantRecalibrator \
  -tranche 100.0 -tranche 99.95 -tranche 99.9 \
  -tranche 99.5 -tranche 99.0 -tranche 97.0 -tranche 96.0 \
  -tranche 95.0 -tranche 94.0 \
  -tranche 93.5 -tranche 93.0 -tranche 92.0 -tranche 91.0 -tranche 90.0 \
  -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa \
  -V finalvcf/merged.vcf.gz \
  --resource:hapmap,known=false,training=true,truth=true,prior=15.0 \
  /fdb/GATK_resource_bundle/hg19/hapmap_3.3.hg19.vcf.gz  \
  --resource:omni,known=false,training=true,truth=false,prior=12.0 \
  /fdb/GATK_resource_bundle/hg19/1000G_omni2.5.hg19.vcf.gz \
  --resource:1000G,known=false,training=true,truth=false,prior=10.0 \
  /fdb/GATK_resource_bundle/hg19/1000G_phase1.snps.high_confidence.hg19.vcf.gz \
  -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR  \
  -mode SNP -O finalvcf/filtering/merged_SNP1.recal --tranches-file finalvcf/filtering/output_SNP1.tranches \
  --rscript-file finalvcf/filtering/output_SNP1.plots.R

gatk --java-options "-Xms4G -Xmx4G" VariantRecalibrator \
  -tranche 100.0 -tranche 99.95 -tranche 99.9 \
  -tranche 99.5 -tranche 99.0 -tranche 97.0 -tranche 96.0 \
  -tranche 95.0 -tranche 94.0 -tranche 93.5 -tranche 93.0 \
  -tranche 92.0 -tranche 91.0 -tranche 90.0 \
  -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa \
  -V finalvcf/merged.vcf.gz \
  --resource:mills,known=false,training=true,truth=true,prior=12.0 \
  /fdb/GATK_resource_bundle/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf.gz \
  --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 \
  /fdb/GATK_resource_bundle/hg19/dbsnp_138.hg19.vcf.gz \
  -an QD -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP \
  -mode INDEL -O finalvcf/filtering/merged_indel1.recal --tranches-file finalvcf/filtering/output_indel1.tranches \
  --rscript-file finalvcf/filtering/output_indel1.plots.R

