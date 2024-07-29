#! /bin/bash
#https://hpc.nih.gov/training/gatk_tutorial/vqsr.html#optimized-script-for-applyvqsr
# Run ApplyVQSR on SNP then INDEL

module load GATK/4.5.0.0

gatk --java-options "-Xms6G -Xmx6G" ApplyVQSR -V finalvcf/merged.vcf.gz 
  --recal-file finalvcf/filtering/merged_SNP1.recal \
  -mode SNP \
  --tranches-file finalvcf/filtering/output_SNP1.tranches \
  --truth-sensitivity-filter-level 99.9 \
  --create-output-variant-index true \
  -O finalvcf/filtering/SNP.recalibrated_99.9.vcf.gz 

gatk --java-options "-Xms6G -Xmx6G" ApplyVQSR -V finalvcf/filtering/SNP.recalibrated_99.9.vcf.gz 
  -mode INDEL \
  --recal-file finalvcf/filtering/merged_indel1.recal \
  --tranches-file finalvcf/filtering/output_indel1.tranches \ 
  --truth-sensitivity-filter-level 99.9 \
  --create-output-variant-index true \
  -O finalvcf/filtering/indel.SNP.recalibrated_99.9.vcf.gz


