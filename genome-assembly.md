## Genome Assembly tutorial (PacBio data) 

Genome assembly refers to the process of putting back together the nucleotide sequences using short or long DNA sequences to create a representation 
of the original chromosome from which the sequences originated. The goal of genome assembly tools is to create long contiguous pieces of sequence 
(contigs) from short or long reads. The contigs are then ordered and oriented in relation to one another to form scaffolds.

Here we will start with pre-trimmed reads and assemble them  using three assembly tools [hifiasm](https://github.com/chhylp123/hifiasm), 
[canu](https://canu.readthedocs.io/en/latest/tutorial.html) and [flye](https://github.com/mikolmogorov/Flye)  

If you are not logged into the HPC, please log in.  

In your home directory, create a directory called `genome-assembly` and change directory to `genome-assembly`

```
mkdir genome-assembly

cd genome-assembly
```



**Running hifiasm**  
- This will take about 8 minutes on 2 cores
```
module load hifiasm/0.16.1

hifiasm -o ecoli -t 2 reducedPB_clean.fastq --primary
```


Convert gfa to fasta


```
awk '/^S/{print ">"$2;print $3}' ecoli.p_ctg.gfa > ecoli.p.fa
```

Discuss the output files

**Running canu**  
- This will take about 22 minutes on 2 cores
```
module load canu/1.8 

canu -d canu/ -p ecoliCanu -pacbio-corrected reducedPB_clean.fastq genomeSize=4m -useGrid=false -merylThreads=2 -merylMemory=8 corOverlapper=ovl

```

Discuss the output files

**Running flye**
- This will take about 12 minutes on 2 cores
```
module load flye/2.9.6 

flye --pacbio-corr reducedPB_clean.fastq -o flye/ --threads 2
```

Discuss the output files


## Assembly statistics 

Compare the three assemblies using QUality ASsessment Tool [QUAST](https://github.com/ablab/quast)


```
module purge

module load quast/4.5

quast.py /home/${USER}/genome-assembly/flye/assembly.fasta  /home/${USER}/genome-assembly/canu/ecoliCanu.contigs.fasta 
/home/${USER}/genome-assembly/ecoli.p.fa -o quast-output/
```

Download and discuss the report 

## Assembly completeness 

We will now assess the completeness of the best assembly from our previous comparison using - Benchmarking Universal Single-Copy Orthologs [BUSCO](https://busco.ezlab.org/)

Run busco

```
module purge

module load BUSCO/5.2.2

busco -m genome -i /home/${USER}/genome-assembly/canu/ecoliCanu.contigs.fasta -o  canuBusco --metaeuk -l eudicots_odb10 -c 2
```

Explore the summary report.
