rm(list = ls())
library(DiscreteFDR)
library(Rcpp)
library(RcppArmadillo)
library(data.table)
source("p.discrete.adjust.R") #library(discreteMTP)
library(nloptr)
library(igraph)
library(devtools)
library(R.utils)
#library(argparse)
library(BiocParallel)
library(IRanges)
library(GenomicRanges)
library(SeqArray)
library(S4Vectors)
source("../CoCoRV/R/CoCoRV.R")
source("../CoCoRV/R/countFunctions.R")
source("../CoCoRV/R/loadHighLDVariants.R")
source("../CoCoRV/R/estimateAFJoint.R")
source("../CoCoRV/R/estimateHighLD.R")
source("../CoCoRV/R/variantSets.R")
source("../CoCoRV/R/support.R")
source("../CoCoRV/R/RcppExports.R")
##Let us try

## association test using summary counts
## if stratified analysis is specified, the AC and AN will still be used for
## filtering and QC, then the counts corresponding to the stratified groups
## will be used in the CMH exact test
load("arguments.RData")
nControl = arguments$nControl
nCase = arguments$nCase
controlGDSFile = arguments$controlGDSFile
caseGDSFile = "merged.nochrnoChrM_removemultialle.out.final.vcf.gds"  #arguments$caseGDSFile
controlAnnoGDSFile = arguments$controlAnnoGDSFile
caseAnnoGDSFile = arguments$caseAnnoGDSFile
sampleList = "sampleList.txt"  #arguments$sampleList
outputPrefix = "./result/NIH"  #arguments$outputPrefix
AFMax = arguments$AFMax
AFUse = arguments$AFUse
AFGroup = arguments$AFGroup
countUse = arguments$countUse
variantMissing = arguments$variantMissing
removeStar = arguments$removeStar
minREVEL = arguments$minREVEL
maxAFPopmax = arguments$maxAFPopmax
ACANConfig = "" #arguments$ACANConfig
caseGroup = "./ethnicityNIH.txt"  #arguments$caseGroup
variantExcludeFile = arguments$variantExcludeFile
variantIncludeFile = arguments$variantIncludeFile
ignoreFilter = arguments$ignoreFilter
variantGroupCustom = arguments$variantGroupCustom
extraParamJason = arguments$extraParamJason
variantGroup = arguments$variantGroup
groupColumn = arguments$groupColumn
annotationUsed = arguments$annotationUsed
bed = arguments$bed
fullCaseGenotype = arguments$fullCaseGenotype
overlapType = arguments$overlapType
pLDControl = arguments$pLDControl
ORThresholdControl = arguments$ORThresholdControl
checkHighLDInControl = arguments$checkHighLDInControl
highLDVariantFile = arguments$highLDVariantFile
ignoreEthnicityInLD = arguments$ignoreEthnicityInLD
gnomADVersion = arguments$gnomADVersion
regionFile = arguments$regionFile
  
# create the output folder
#if (!file.exists(dirname(outputPrefix))) {
#  dir.create(dirname(outputPrefix), recursive = T)
#} 
  
resultPerRegion = CoCoRV(controlGDSFile = controlGDSFile,
                           caseGDSFile = caseGDSFile,
                           controlAnnoGDSFile = controlAnnoGDSFile,
                           caseAnnoGDSFile = caseAnnoGDSFile,
                           nControl = nControl,
                           nCase = nCase,
                           sampleList = sampleList,
                           outputPrefix = paste0(outputPrefix, "_new"),  #changed the name of output
                           AFMax = AFMax,
                           AFUse = AFUse,
                           AFGroup = AFGroup,
                           countUse = countUse,
                           variantMissing = variantMissing,
                           removeStar = removeStar,
                           minREVEL = minREVEL,
                           maxAFPopmax = maxAFPopmax,
                           ACANConfig = ACANConfig,
                           caseGroup = caseGroup,
                           variantExcludeFile = variantExcludeFile,
                           variantIncludeFile = variantIncludeFile,
                           ignoreFilter = ignoreFilter,
                           variantGroupCustom = variantGroupCustom,
                           extraParamJason = extraParamJason,
                           variantGroup = variantGroup,
                           groupColumn = groupColumn,
                           annotationUsed = annotationUsed,
                           bed = bed,
                           fullCaseGenotype = fullCaseGenotype,
                           overlapType = overlapType,
                           pLDControl = pLDControl,
                           ORThresholdControl = ORThresholdControl,
                           checkHighLDInControl = checkHighLDInControl,
                           gnomADVersion = gnomADVersion,
                           highLDVariantFile = highLDVariantFile,
                           ignoreEthnicityInLD = ignoreEthnicityInLD,
                           regionFile = regionFile)
  
  
  if (length(resultPerRegion) > 0) {
    file.create(paste0(outputPrefix, "_new.case.group"))
    file.create(paste0(outputPrefix, "_new.control.group"))
    caseGroup = file(paste0(outputPrefix, "_new.case.group"), open = "a")
    controlGroup = file(paste0(outputPrefix, "_new.control.group"), open = "a")
    for (i in 1:length(resultPerRegion)) {
      result = resultPerRegion[[i]]
      regionID = result$regionID
      
      if (regexpr("sample", countUse) != -1) {
        # output the group list files
        caseGroupLines = sapply(1:length(result$caseGeneList),
                                function(x) paste(result$caseGeneList[[x]], collapse=" "))
        controlGroupLines = sapply(1:length(result$controlGeneList),
                                   function(x) paste(result$controlGeneList[[x]], 
                                                     collapse=" "))
        if (!is.null(regionID)) {
          caseGroupLines = paste(regionID, caseGroupLines)
          controlGroupLines = paste(regionID, controlGroupLines)
          result$testResult = cbind(regionID, result$testResult)
        }
        writeLines(caseGroupLines, con = caseGroup)
        writeLines(controlGroupLines, con = controlGroup)
      }
      
      # output the test result
      if (i == 1) {
        write.table(result$testResult, 
                    file = paste0(outputPrefix, "_new.association.tsv"), 
                    row.names = F, col.names = T, sep = "\t", quote = F)
      } else {
        write.table(result$testResult, 
                    file = paste0(outputPrefix, "_new.association.tsv"), 
                    row.names = F, col.names = F, sep = "\t", quote = F, 
                    append = T)
      }
    }
    close(caseGroup)
    close(controlGroup)
  }
  
  cat("Analysis Done!\n")

