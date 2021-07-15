#!/usr/bin/env nextflow

/*
* A pipeline for running genetic demultiplexing methods - souporcell and 
* demuxlet
*
* Parameters:
*   - bam: bam input file
*   - yaml: yaml file that describes the run
*   - output: output directory for souporcell
*   - dataType: RNA or ATAC
*   - vcf: vcf file
*/
    
    params.yaml = ""
    params.samplename = "output"
    params.input = "NO_FILE"
    params.barcode = "NO_FILE"
    params.dataType = "RNA"
    params.vcf = "NO_FILE"
    params.clusters = 3
    params.threads = 28
    params.fasta = "NO_FILE"
    params.souporcellSif = "NO_FILE"
    params.demuxletSif = "NO_FILE"
    params.outdir = "."
    // input = file(params.bam)
    vcf = file(params.vcf)
    params.isAtac = "False"
    if(params.dataType == "ATAC") params.isAtac = "True"
    process demuxRun {
      //  label 'demuxRun'
      //  label 'short'
        publishDir path:params.outdir, mode:'copy'
        cpus 28
        input:
       //     file infile from input
        output:
           file "output/*.txt" into out1
           file "output/*.tsv" into out2
        script:
        // def instr = infile.name != "NO_FILE" ? "-i $infile" : ''
        // each mode from methods
        // if( mode == 'souporcell' )
        """
       singularity exec ${params.souporcellSif} souporcell_pipeline.py  --bam ${params.input} -b ${params.barcode} -f ${params.fasta} --known_genotypes ${params.vcf} --known_genotypes_sample_names C57BL_6NJ NZO_HlLtJ CAST_EiJ --ploidy 2 --min_alt 10 --min_ref 10 --no_umi False -t ${params.threads} -o output -k ${params.clusters} --ignore True
        """
        }
 
