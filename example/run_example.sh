#!/bin/bash

# Define a list of files/directories to be cleaned.
output_dirs=( "phenoAB_out" "PP_genome.fa.dict")

# Ensure exactly one argument is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {prep|align|analyze|stats|all|clean}"
    exit 1
fi

case "$1" in
prep)
    echo "Prepping the genome..."
    GENOME="PP_genome.fa"	
    # 1) Index fastA genome file with bwa   
    bwa index -a bwtsw ${GENOME}
    # 2) Create fastA file index as well
    samtools faidx ${GENOME}
    # 3) Create sequence dictionary with picardtools (Java)
    java -Xmx2g -jar /usr/local/bin/picard.jar CreateSequenceDictionary REFERENCE= ${GENOME} OUTPUT=${GENOME}.dict
;;

align)
    echo "Running PP_align.sh..."
    PPalign pp_align.config
;;

analyze)
    echo "Running PP_analyze.sh..."
    PPanalyze pp_analyze.config
;;

stats)
    echo "Running PP_stats.sh..."
    PPstats pp_stats.config
;;

all)
    echo "Running full pipeline (prep, align, analyze, stats)..."
    "$0" prep
    "$0" align
    "$0" analyze
    "$0" stats
;;

clean)
    echo "Cleaning output directories and files..."
    for target in "${output_dirs[@]}"; do
        echo "Removing $target"
        rm -rf "$target"
    done
;;

*)
    echo "Invalid option: $1"
    echo "Usage: $0 {align|analyze|stats|all|clean}"
    exit 1
;;
esac
