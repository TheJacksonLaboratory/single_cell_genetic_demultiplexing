#!/bin/bash
#SBATCH -p compute -q batch
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem=64GB # memory pool for all cores
#SBATCH -t 2-20:00 # time (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR
#SBATCH --mail-user=vivek.kohar@jax.org
#SBATCH --mail-type=ALL

module load singularity
singularity exec demuxlet_1.0--h089eab3_2.sif demuxlet --sam /projects/koharv/CWD/souporcell/MS20015/demux_data_test/souporcell_minimap_tagged_sorted.bam --vcf /projects/koharv/CWD/souporcell/cube_3bears.vcf --out MS20015 --tag-group CB --field GT
