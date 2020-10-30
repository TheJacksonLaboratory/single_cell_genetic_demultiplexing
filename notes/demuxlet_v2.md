# Running `demuxlet` v2

Here are some notes on running `demuxlet` version 2.
I am working with the code available at https://github.com/statgen/popscle. 
I made a singularity container. You can access it on `sumner` at 
`/projects/skelld/sif/popscle-1.0.sif`. I have some example code on 
`sumner` in `/projects/skelld/shared/genetic_demultiplexing/demuxlet_v2`.

I found that we can run `demuxlet` in one of two ways:

 1. We can run using just a BAM, VCF, and barcode file.
    See an example in `/projects/skelld/shared/genetic_demultiplexing/demuxlet_v2/run_demuxlet_v2.slurm`.
 2. We can run demuxlet in a two-step process:
   * First run `dsc-pileup` - see `/projects/skelld/shared/genetic_demultiplexing/demuxlet_v2/run_dsc_pileup.slurm`.
   * Second run `demuxlet` using the pileup files produced by `dsc-pileup` - see `/projects/skelld/shared/genetic_demultiplexing/demuxlet_v2/run_demuxlet_plp.slurm`.

We should favor the second approach, running demuxlet in a two-step process. 
This way allows us more flexibility because we can run demuxlet multiple 
times in order to look at variability in parameter choices.

In general, for all (or nearly all?) use cases in a pipeline/workflow,
I think we should be able to run `dsc-pileup` with a VCF file
containing all mouse population-level variants (e.g. the VCF of all strains
from the Sanger Mouse Genomes Project). This could be a universal 
pre-processing step for mouse single cell pooled data.
Then when running `demuxlet` we
would specify a VCF that has only the strains of interest.
