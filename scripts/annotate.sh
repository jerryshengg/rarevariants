module load bcftools
# usage: bash <script> ${vcfFile} ${annovarFolder} ${refbuild} ${outputPrefix} [${VCFAnno} ${toml}] [${protocol} ${operation}]

# databases from annovar has multiple lines for the same variant. I think this is mainly to maintain its compatibility with tghe vcf format and the previous annovar's previous av format
# !!!! there are some inconsistencies about how indels are represented. So some indels will not be annotated if the representation is different from annovar gnomad or gnomad itself
# This is weird but true, e.g., * in our data but not in gnomad even though both are called by GATK.

# input
vcfFile="./merged.nochrnoChrM_removemultialle.vcf"
annovarFolder="/fdb/annovar/current/hg19"
refBuild="hg19"  # hg19 or hg38
outputPrefix="./merged.nochrnoChrM_removemultialle.out"

##if [[ "$#" -ge 5 ]]; then
##  VCFAnno=$5
##  toml=$6
##fi

#protocol="refGene,gnomad211_exome,gnomad_exome,gnomad_genome,1000g2015aug_all,exac03nontcga,dbnsfp35a,revel,clinvar_20190305,intervar_20180118"
#operation="g,f,f,f,f,f,f,f,f,f"
protocol="refGene,gnomad211_exome,revel,dbnsfp35a"
operation="g,f,f,f"
##if [[ $# -ge 7 ]]; then
##  protocol=$7
##  operation=$8
##fi

## annotate with annovar
module load annovar
mkdir -p $(dirname ${outputPrefix})
vcfPlain=${outputPrefix}.unzipped.vcf
bcftools view -G -Ou ${vcfFile} | bcftools annotate -x ^INFO/AC -o ${vcfPlain} 
table_annovar.pl ${vcfPlain} ${annovarFolder}/ -buildver ${refBuild} -out ${outputPrefix}.annovar \
-remove -protocol ${protocol} -operation ${operation} \
-nastring . -vcfinput > ${outputPrefix}.annovar.log

# change annotation type after annotation for later bcftools filtering and
# some irregular annotation
sed -i -e '/^##INFO=<ID=gnomAD/s/Type=String/Type=Float/' -e '/^##INFO=<ID=ExAC_nontcga/s/Type=String/Type=Float/' -e '/^##INFO=<ID=CADD/s/Type=String/Type=Float/' -e '/^##INFO=<ID=REVEL/s/Type=String/Type=Float/' -e 's/Eigen-/Eigen_/g' -e 's/GERP++/GERPpp/g' -e 's/PC-/PC_/g' -e 's/M-CAP/M_CAP/g' -e 's/fathmm-/fathmm_/g' ${outputPrefix}.annovar.${refBuild}_multianno.vcf

# zip and tabix
bcftools annotate --set-id '%CHROM-%POS-%REF-%ALT' ${outputPrefix}.annovar.${refBuild}_multianno.vcf | bgzip -c > ${outputPrefix}.vcf.gz 
tabix -f -p vcf ${outputPrefix}.vcf.gz

# annotate with topmed
#if [[ "$#" -ge 5 && ${VCFAnno} != "NA" ]]; then
#  outputRoot=$(dirname ${outputPrefix}.vcf.gz)/withTopmed
#  outputFile=${outputRoot}/$(basename ${outputPrefix}).vcf.gz
#  mkdir -p ${outputRoot}
#  vcf=${outputPrefix}.vcf.gz
#  ${VCFAnno} -p 1 -lua $(dirname ${VCFAnno})/example/custom.lua \
#      ${toml} ${vcf} | bgzip > ${outputFile} && \
#      tabix -p vcf ${outputFile}
#fi

# clean
rm ${vcfPlain}
rm ${outputPrefix}.annovar.${refBuild}_multianno.vcf ${outputPrefix}.annovar.${refBuild}_multianno.txt ${outputPrefix}.annovar.avinput

bgzip -c ${vcfFile} > ${vcfFile}.gz 
tabix -f -p vcf ${vcfFile}.gz


vcfAnnotatedFinal="./merged.nochrnoChrM_removemultialle.out.final.vcf.gz"
vcfAnnotated="./merged.nochrnoChrM_removemultialle.vcf.gz"
bcftools annotate -a ${outputPrefix}.vcf.gz -c INFO -Oz -o ${vcfAnnotatedFinal} ${vcfAnnotated}



