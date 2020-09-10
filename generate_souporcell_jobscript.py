#!/usr/bin/env python

"""
Generate a script for job submission of souporcell
"""
import sys, argparse, os
username = os.environ['USER']

def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    requiredNamed = parser.add_argument_group('required named arguments')
    requiredNamed.add_argument('--datatype', help='RNA or ATAC', required=True, metavar='RNA', choices=['RNA', 'ATAC'])
    requiredNamed.add_argument('-d', '--dir', help='Cellranger directory', required=True)
    requiredNamed.add_argument('--jobfile', help="SLURM submit file name", required=True, metavar='file.slurm')
    requiredNamed.add_argument('-K', help="Number of genotype clusters", required=True, nargs='+', type=int)
    requiredNamed.add_argument('-o', '--outdir', help='Base for output directory', required=True)
    parser.add_argument("--known_genotypes", default=None)
    parser.add_argument("--min_alt", type=int, default=10)
    parser.add_argument("--min_ref", type=int, default=10)
    parser.add_argument("--ploidy", type=int, default=2)
    parser.add_argument("--tmpdir", help='Dir where big files are stored', default='/fastscratch/{}'.format(username))
    parser.add_argument("--save_tmpdir", action="store_true", help="save tempdir of intermediate files")
    args = parser.parse_args()
    
    if not os.path.isdir(args.tmpdir):
        os.mkdir(args.tmpdir)
    
    # Set up output directories
    for K in args.K:
        final_outdir = os.path.abspath("{}_K{}".format(args.outdir, K))
        assert not os.path.isdir(final_outdir), "Output directory {} already exists!".format(final_outdir)
    temp_outdir_path = os.path.abspath("{}/{}_K$K".format(args.tmpdir, os.path.basename(args.outdir)))
    final_outdir_path = os.path.abspath("{}_K$K".format(args.outdir))  # 'template' path for slurm script
    
    # Some config parameters
    if args.datatype == "ATAC":
        no_umi = True
        assert os.path.exists('{}/filtered_peak_bc_matrix/barcodes.tsv'.format(args.dir))
        barcodes = 'ln -s {}/filtered_peak_bc_matrix/barcodes.tsv'.format(args.dir)
        bamfile = "{}/possorted_bam.bam".format(args.dir)
        assert os.path.exists(bamfile)
    else:
        no_umi = False
        assert args.datatype == "RNA"
        assert os.path.exists('{}/filtered_feature_bc_matrix/barcodes.tsv.gz'.format(args.dir))
        barcodes = 'zcat {}/filtered_feature_bc_matrix/barcodes.tsv.gz > barcodes.tsv'.format(args.dir)
        bamfile = "{}/possorted_genome_bam.bam".format(args.dir)
        assert os.path.exists(bamfile)
    
    # optional args
    args_var = '--ploidy {} --min_alt {} --min_ref {}'.format(args.ploidy, args.min_alt, args.min_ref)
    if args.known_genotypes is None:
        samples = ""
        kg = ""
    else:
        args.known_genotypes = os.path.abspath(args.known_genotypes)
        samples = "SAMPLES=$(singularity exec /projects/skelld/sif/vcflib_conda_alpine.sif vcfsamplenames {})".format(args.known_genotypes)
        kg = "--known_genotypes {} --known_genotypes_sample_names $SAMPLES".format(args.known_genotypes)
    
    # Final checks
    assert os.path.exists('/projects/skelld/10x/refdata-cellranger-mm10-3.0.0/fasta/genome.fa')
    orig_dir = os.getcwd()
    
    # Write the job submit script
    assert not os.path.exists(args.jobfile), "{} already exists".format(args.jobfile)
    f = open(args.jobfile, 'w')
    f.write("""#!/bin/bash
#SBATCH --job-name=run_souporcell
#SBATCH --partition=compute  # ==queue
#SBATCH --nodes=1            # number of nodes
#SBATCH --ntasks=20          # number of cores
#SBATCH --mem=200G
#SBATCH --time=20:00:00      # time (HH:MM:SS)
#SBATCH --output=%x.o%A_%a      # stdout and stderr
#SBATCH --array={}

module load singularity
K=$SLURM_ARRAY_TASK_ID

TMP_OUTDIR={}
FINAL_OUTDIR={}
if [ -d "$FINAL_OUTDIR" ] 
then
    echo "Dir $FINAL_OUTDIR already exists!"
    exit 1
else
    mkdir -p $FINAL_OUTDIR
fi
echo "Storing results in $FINAL_OUTDIR"
mkdir -p $TMP_OUTDIR
cd $TMP_OUTDIR
{}    # zcat cmd for barcodes file
{}    # if necessary to get samples from known genotypes VCF
echo "SAMPLES=$SAMPLES"
    
echo "Running souporcell:"
singularity exec /projects/skelld/sif/souporcell.sif souporcell_pipeline.py \\
    --no_umi {} {} {} \\
    -i {} \\
    -b barcodes.tsv \\
    -f /projects/skelld/10x/refdata-cellranger-mm10-3.0.0/fasta/genome.fa \\
    -t 20 -o $TMP_OUTDIR/run -k $K
RETCODE=$?
echo "Return code was $RETCODE"
if [ $RETCODE -ne 0 ]; then
    exit $RETCODE
fi

cp run/clusters.tsv $FINAL_OUTDIR
cp run/cluster_genotypes.vcf $FINAL_OUTDIR
cp run/ambient_rna.txt $FINAL_OUTDIR
cd $FINAL_OUTDIR
""".format(','.join([str(item) for item in args.K]), \
           temp_outdir_path, final_outdir_path, barcodes, samples, no_umi, args_var, kg, bamfile))
    
    if not args.save_tmpdir:
        f.write("rm -rf $TMP_OUTDIR\n")
    
    f.close()


if __name__ == "__main__":
    sys.exit(main())
