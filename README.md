# Single cell genetic demultiplexing

This repo gives some scripts for working with pooled single cell functional
genomics data in order to demultiplex genetic backgrounds.

 * `generate_souporcell_jobscript.py` = a python script that generates a
    slurm job submission script for a souporcell demultiplexing job.
    Mostly (entirely?) uses singularity containers to run various 
    executables. I've made these singularity containers readable and 
    executable for all users, so hopefully this job submission script 
    will work for anyone.
 * `cube_3bears.pbs`, `reheader_switch_MT.sh`, `reheader_switch_MT.py` = 
    a job submission script and accessory scripts
    (old, from back when helix was in service)
    showing how I made the Cube three bears VCF file
 * `run_demuxlet.pbs` = an old job submission script (from helix) giving
    an example command that I used to successfully run demuxlet. 
    May be out of date. There is 
    currently a newer version of the software that I have not yet used.
 * `simulation` = a directory of scripts that gives some examples for running
    a scRNA-Seq simulation using `minnow` (https://github.com/COMBINE-lab/minnow).
    First clone the minnow repository, build the software, and download files from
    https://doi.org/10.5281/zenodo.3276716. The idea is that `minnow` could be used
    to simulate raw FASTQ reads which could then be used as input to Cellranger and
    finally demultiplexed. We would have a "ground truth" with such simulated
    data.

