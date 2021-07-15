#!/bin/bash
#SBATCH -p compute -q batch
#SBATCH -N 1 # number of nodes
#SBATCH -n 29 # number of cores
#SBATCH --mem=250GB # memory pool for all cores
#SBATCH -t 2-20:00 # time (D-HH:MM)
#SBATCH -o slurm.%j.out # STDOUT
#SBATCH -e slurm.%j.err # STDERR
#SBATCH --mail-user = vivek.kohar@jax.org
module load singularity
mkdir $1
## gunzip -c /projects/rosenthal-lab/cube/genetic_demultiplexing/sc-data-rerun/cube_atac_2021/$1/cellranger/filtered_peak_bc_matrix/barcodes.tsv.gz > /fastscratch/koharv/rna/$1/barcodes.tsv

nextflow run mainSoupCellAtac.nf --samplename $1 --outdir $1 --isAtac True --souporcellSif /projects/koharv/singularityImages/souporcell.sif --input /projects/rosenthal-lab/cube/genetic_demultiplexing/sc-data-rerun/cube_atac_2021/$1/cellranger/possorted_bam.bam --barcode /projects/rosenthal-lab/cube/genetic_demultiplexing/sc-data-rerun/cube_atac_2021/$1/cellranger/filtered_peak_bc_matrix/barcodes.tsv --fasta /projects/rosenthal-lab/cube/genetic_demultiplexing/sc-data-rerun/refdata-gex-mm10-2020-A/fasta/genome.fa --vcf /projects/rosenthal-lab/cube/genetic_demultiplexing/vivek/souporcell/cube_3bears_atac.vcf

