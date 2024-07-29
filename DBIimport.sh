#!/bin/bash
# Jerry Sheng
# Import genotypes into database 

module load GATK/4.5.0.0

# Create temporary directory if not exists
mkdir -p tmp
mkdir -p gatk_ped

# Read file names from filesTMT
readarray -t file_list < "filesTMT"

# Loop over chromosome numbers
for j in {1..22}
do
    # Create directory for each chromosome
    mkdir -p tmp/chr${j}_gdb
    
    # Initialize the command with common options
    command="gatk GenomicsDBImport --genomicsdb-workspace-path tmp/chr${j}_gdb -R /fdb/igenomes/Homo_sapiens/UCSC/hg19/Sequence/BWAIndex/genome.fa"

    # Append each VCF file from file_list
    for file in "${file_list[@]}"
    do
        command+=" -V vcf/${file}"
    done

    # Add additional parameters
    command+=" --tmp-dir tmp --max-num-intervals-to-import-in-parallel 3 --intervals chr${j}"

    # Execute the command
    eval "$command"

    # Copy the final results to your data directory
    cp -r tmp/chr${j}_gdb gatk_ped/
done
