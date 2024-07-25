# rarevariants
Pipeline for rare variant association analysis (FASTQ --> TSV association file from CoCoRV). Examples use whole exome sequencing files. 

1. Run variantcalling.sh with FASTQ sample inputs to get gvcf file for each sample
2. Run DBIimport.sh to save genotype information
3. Run genotype.sh to get genotype of all chomosomes and merge into one gvcf file.
4. Run VariatRecalibrate.sh
5. Run ApplyVQSR.sh
6. Run variant_filt
7. In finalvcf/filteringdbsnp folder, unzip merged.vcf
8. In removeChrChrM_removemultialle.pl to get merged.nochrnoChrM_removemultialle.vcf
9. In annotate_Jerry.sh for annotation of annovar
10. Run vcf2gds.R change vcf.gz to gds file
11. Run debug_R420PChome_code__removemultialle.R to get the result
