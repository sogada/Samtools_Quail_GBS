#!/bin/env bash

#set -e ensures that our script will exit if an error occurs
set -e
cd ~/Desktop/OGADA/agdata/results

#tell our script where to find the reference genome
genome=~/Desktop/OGADA/agdata/ref_genome/cocos_nucifera_refseq.fna
bams=~/Desktop/OGADA/agdata/results/bam/*.aligned.sorted.fix.sort.markdup.bam

#create the directories sam bam bcf vcf to store our results in
mkdir -p vcf

#run mpileup, you can add fields like AD using FORMAT/AD
bcftools mpileup -A -a FORMAT/DP,FORMAT/SP -Ou -f $genome $bams | bcftools call -mv -f GQ,GP -O z -o ~/Desktop/OGADA/agdata/results/vcf/cocosraw.vcf.gz