# Demultiplexing of snATAC-Seq data

## `Demuxlet` v2

It looks like `demuxlet` version 2 should work just fine on 10X 
Genomics ATAC data. See 
[this link](https://github.com/statgen/popscle/blob/6798538c248f04fc2f62a43ecdf0d30a58296722/tutorials/README_atac.md) 
from their github repo.

## `souporcell`

I had success running `souporcell` on ATAC data using a command like
```
singularity exec souporcell.sif souporcell_pipeline.py \
    --ploidy 1 --min_alt 10 --min_ref 10 --no_umi True -i $BAM \
    -b $BARCODE_FILE -f genome.fa -t 20 -o $OUTDIR -k $K \
    --known_genotypes cube_3bears.vcf \
    --known_genotypes_sample_names C57BL_6NJ NZO_HlLtJ CAST_EiJ
```
In the code the parameters `min_alt` and `min_ref` are tunable and 
may need to be optimized.
