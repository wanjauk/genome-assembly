## Genome Assembly tutorial (PacBio data) 

Genome assembly refers to the process of putting back together the nucleotide sequences using short or long DNA sequences to create a representation 
of the original chromosome from which the sequences originated. The goal of genome assembly tools is to create long contiguous pieces of sequence 
(contigs) from short or long reads. The contigs are then ordered and oriented in relation to one another to form scaffolds.

Here we will start with pre-trimmed reads and assemble them  using three assembly tools [hifiasm](https://github.com/chhylp123/hifiasm), 
[canu](https://canu.readthedocs.io/en/latest/tutorial.html) and [flye](https://github.com/mikolmogorov/Flye)  

If you are not logged into the HPC, please log in.  

**Setting up**

In your home directory, create a directory called `genome-assembly` and change directory to `genome-assembly`

```
mkdir genome-assembly

cd genome-assembly
```

Enter into an interactive session
```
interactive -c 2
```

Create a symbolic link for the input data and a slurm script.

```
ln -s  /var/scratch/global/aspergillus/SRR31719412_subset_5k.fastq reducedPB_clean.fastq

ln -s /var/scratch/global/slurm/assemble-genome.sh .

ln -s /var/scratch/global/busco/busco-v6.1.0.sif .
```

We will run a job that will be orchestrated by slurm on the compute nodes. The job constists of the steps that take relatively long time to complete.

```
#sbatch assemble-genome.sh
```  

**Running hifiasm**  
```
module load hifiasm/0.16.1

hifiasm -o aspn -t 2 reducedPB_clean.fastq
```


Convert gfa to fasta


```
awk '/^S/{print ">"$2;print $3}' aspn.p_ctg.gfa > aspn.p.fa
```

Discuss the output files

**Running canu**  
```
module load canu/1.8 

canu -d canu/ -p aspnCanu -pacbio-corrected reducedPB_clean.fastq genomeSize=34m -useGrid=false -merylThreads=2 -merylMemory=8 corOverlapper=ovl

```

Discuss the output files

**Running flye**
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

quast.py /home/${USER}/genome-assembly/flye/assembly.fasta  /home/${USER}/genome-assembly/canu/aspnCanu.contigs.fasta 
/home/${USER}/genome-assembly/aspn.p.fa -o quast-output/
```

Download and discuss the report 

## Assembly completeness 

We will now assess the completeness of the best assembly from our previous comparison using - Benchmarking Universal Single-Copy Orthologs [BUSCO](https://busco.ezlab.org/)

Run busco

```
apptainer run busco-v6.1.0.sif busco -m genome -i /home/${USER}/genome-assembly/canu/aspnCanu.contigs.fasta -o  canuBusco --metaeuk -l eudicots_odb10 -c 2

```

Explore the summary report.
