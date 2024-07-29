#! /bin/bash
module load GATK/4.5.0.0
#mkdir tmp
for j in {1..22} 
do
#mkdir tmp/chr${j}_gdb 
gatk GenomicsDBImport --genomicsdb-workspace-path tmp/chr${j}_gdb -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa \
-V vcf/NIH005_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH006_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH009_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH018_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH019_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH021_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH024_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH025_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH027_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH035_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH040_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH042_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH043_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH044_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH045_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH053_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH075_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH076_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH133_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH135_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH146_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH155_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH169_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH194_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH197_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH199_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH207_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH219_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH226_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH235_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH245_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH254_normal.HaplotypeCaller.g.vcf \
-V vcf/NIH280_normal.HaplotypeCaller.g.vcf \
--tmp-dir tmp \
--max-num-intervals-to-import-in-parallel 3 \
--intervals chr${j}
# copy the final results to your data directory
cp -r tmp/chr${j}_gdb gatk_ped/

done

