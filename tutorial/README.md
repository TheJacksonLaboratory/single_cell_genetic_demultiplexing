# Tutorial on genetic demultiplexing using CC/DO founder data

To run genetic demultiplexing, you will need a BAM file of aligned reads
(the CellRanger BAM works well), the cell barcodes you want to
examine (again the CellRanger barcodes file works), and a VCF file
giving genotypes of the strains in your pool.


## VCF containing strains in your pool

Find a founder strain VCF at
`/projects/skelld/shared/genetic_demultiplexing/CC_founders.vcf.gz`

This VCF was made using `CC_founders.pbs` (in this repo).
Note that in the VCF file, I used C57BL/6NJ rather than /6J – this is a 
surrogate for B6 as the two lines only differ by a couple hundred variants. 
The reason is that it’s cumbersome to create a column in a VCF file for the 
reference strain.

The job script `CC_founders.pbs` no longer works on our SLURM system
but the `bcftools` commands I used to filter the Sanger Mouse Genomes
Project VCF files should work.


## Software

We used two different genetic demultiplexing algorithms:

 * `souporcell` https://github.com/wheaton5/souporcell
 * `demuxlet` https://github.com/statgen/popscle/

I have containers at

 * `souporcell` - `/projects/skelld/sif/souporcell.sif` or [here](http://jaxreg.jax.org/containers/488)
 * `demuxlet` - `/projects/skelld/sif/popscle-1.0.sif` or [here](http://jaxreg.jax.org/containers/486)

## Running the demultiplexing

Here are some example commands. I gratefully acknowledge contributions from Vivek Kohar 
and Marina Yurieva on running each of these software options!

### Souporcell

We have a NextFlow pipeline. Look at the following files in this repo:
```
jobSoupCellAtac.sh
jobSoupCellRna.sh
mainSoupCellAtac.nf
mainSoupCellRna.nf
```

### Demuxlet

```
# RNA
singularity run popscle-1.0.sif demuxlet --sam $bam --vcf $vcf --out $output \
    --sam-verbose 10000000 --vcf-verbose 250000 --alpha 0.0 --alpha 0.5 \
    --tag-group CB --tag-UMI UB --field GT  --group-list $barcodes
# ATAC
singularity run popscle-1.0.sif demuxlet --sam $bam --vcf $vcf --out $output \
    --sam-verbose 10000000 --vcf-verbose 250000 --alpha 0.0 --alpha 0.5 \
    --tag-group CB --field GT  --group-list $barcodes
```
