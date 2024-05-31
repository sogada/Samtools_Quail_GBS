#!/bin/env bash

#set -e ensures that our script will exit if an error occurs
set -e
cd ~/Desktop/OGADA/agdata/results

#tell our script where to find the reference genome
genome=~/Desktop/OGADA/agdata/ref_genome/cocos_nucifera_refseq.fna

#index our reference genome for BWA and SAMtools
bwa index $genome
samtools faidx $genome

#create the directories sam bam bcf vcf to store our results in
mkdir -p sam bam  

#assign name of fastq we working with to variable fq1 and echo which one
for fq1 in ~/Desktop/OGADA/agdata/clean_fastq/*_1.fq
    do
    echo "working with file $fq1"

    #extract the base name of the file, assign it to a new variable called base.
    base=$(basename $fq1 _1.fq)
    echo "base name is $base"

    fq1=~/Desktop/OGADA/agdata/clean_fastq/${base}_1.fq
    fq2=~/Desktop/OGADA/agdata/clean_fastq/${base}_2.fq
    sam=~/Desktop/OGADA/agdata/results/sam/${base}.aligned.sam
    bam=~/Desktop/OGADA/agdata/results/bam/${base}.aligned.bam
    sorted_bam=~/Desktop/OGADA/agdata/results/bam/${base}.aligned.sorted.bam
    sorted_bam_fix=~/Desktop/OGADA/agdata/results/bam/${base}.aligned.sorted.fix.bam
    sorted_bam_fix_sort=~/Desktop/OGADA/agdata/results/bam/${base}.aligned.sorted.fix.sort.bam
    sorted_bam_fix_sort_markdup=~/Desktop/OGADA/agdata/results/bam/${base}.aligned.sorted.fix.sort.markdup.bam

    bwa mem -t 4 -P -M $genome $fq1 $fq2 > $sam
    samtools view -S -b $sam > $bam
    samtools sort -n -o $sorted_bam $bam
    samtools fixmate -m $sorted_bam $sorted_bam_fix
    samtools sort -o $sorted_bam_fix_sort $sorted_bam_fix
    samtools markdup $sorted_bam_fix_sort $sorted_bam_fix_sort_markdup
    samtools index $sorted_bam_fix_sort_markdup
   
    done
