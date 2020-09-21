#!/bin/bash
#SBATCH -p compute -q batch
#SBATCH -N 1 # number of nodes
#SBATCH -n 28 # number of cores
#SBATCH --mem=256GB # memory pool for all cores
#SBATCH -t 2-20:00 # time (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR
#SBATCH --mail-user=vivek.kohar@jax.org
#SBATCH --mail-type=ALL

module load singularity
singularity exec ../souporcell.sif souporcell_pipeline.py -i /projects/koharv/CWD/souporcell/MS19046/cellranger/possorted_genome_bam.bam -b /projects/koharv/CWD/souporcell/MS19046/cellranger/filtered_feature_bc_matrix/barcodes.tsv -f /projects/koharv/CWD/demuxlet/GRCm38_68.fa --common_variants /projects/koharv/CWD/souporcell/cube_3bears.vcf -t 28 -o demux_data_test -k 3
