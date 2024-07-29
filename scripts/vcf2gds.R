##R4.2.2 biowulf
rm(list = ls())
library(SeqArray)

# convert vcf to gds 
vcfFile = "merged.nochrnoChrM_removemultialle.out.final.vcf.gz"
gdsFile = "merged.nochrnoChrM_removemultialle.out.final.vcf.gds"
ncore = 1
ignore.chr.prefix = "chr"

seqVCF2GDS(vcfFile, gdsFile, parallel = ncore, ignore.chr.prefix=ignore.chr.prefix)

##R4.2.2 biowulf
rm(list = ls())
library(SeqArray)

# convert vcf to gds 
vcfFile = "NIH_normal.merged.filtered-snps.final.nochrnoChrM.vcf.gz"
gdsFile = "NIH_normal.merged.filtered-snps.final.nochrnoChrM.vcf.gds"
ncore = 1
ignore.chr.prefix = "chr"

seqVCF2GDS(vcfFile, gdsFile, parallel = ncore, ignore.chr.prefix=ignore.chr.prefix)

##R4.2.2 biowulf
rm(list = ls())
library(SeqArray)

# convert vcf to gds 
vcfFile = "NIH_normal.merged.filtered-snps.final.nochrnoChrM_removemultialle.vcf.gz"
gdsFile = "NIH_normal.merged.filtered-snps.final.nochrnoChrM_removemultialle.vcf.gds"
ncore = 1
ignore.chr.prefix = "chr"

seqVCF2GDS(vcfFile, gdsFile, parallel = ncore, ignore.chr.prefix=ignore.chr.prefix)
