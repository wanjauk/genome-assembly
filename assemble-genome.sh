#!/usr/bin/env bash
#SBATCH -p batch
#SBATCH -J assemble-genome
#SBATCH -n 2

module load hifiasm/0.16.1
module load canu/1.8 
module load flye/2.9.6  

# Run hifiasm
hifiasm -o ecoli -t 2 reducedPB_clean.fastq --primary

# Convert gfa to fasta
awk '/^S/{print ">"$2;print $3}' ecoli.p_ctg.gfa > ecoli.p.fa

# Run canu
canu -d canu/ -p ecoliCanu -pacbio-corrected reducedPB_clean.fastq genomeSize=4m -useGrid=false -merylThreads=2 -merylMemory=8 corOverlapper=ovl

# Run flye
flye --pacbio-corr reducedPB_clean.fastq -o flye/ --threads 2

