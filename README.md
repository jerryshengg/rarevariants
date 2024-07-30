# rarevariants
Pipeline for rare variant association analysis (FASTQ --> TSV association file from CoCoRV). Examples use whole exome sequencing files. 

1. Run variantcalling.sh with FASTQ sample inputs to get gvcf file for each sample
2. Run DBIimport.sh to save genotype information
3. Run genotype.sh to get genotype of all chomosomes and merge into one gvcf file.
4. Run VariantRecalibrate.sh
5. Run ApplyVQSR.sh
6. Run variant_filt.sh
7. In finalvcf/filteringdbsnp folder, unzip merged.vcf.gz file
8. Run removeChr_ChrM_Multialle.pl to get merged.nochrnoChrM_removemultialle.vcf
9. Run annotate.sh for annotation of VCF file using annovar
10. Run vcf2gds.R convert vcf.gz to gds file
11. Run CoCoRV_debugged.R to get association.tsv results 

Jerry Sheng and Dr. Shouguo Gao, NHLBI
