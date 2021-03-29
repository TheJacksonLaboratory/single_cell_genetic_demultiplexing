# Can run this script using
# sumner:/projects/skelld/sif/doubletfinder_r4.0.4.sif
library(tidyverse)
library(Seurat)
library(DoubletFinder)

# NOTE: Apply this script to each 10X channel/sample individually.
# Never run this script on cells that were processed in different samples.

# Specify (1) a CellRanger filtered output directory as argument to the script
# and (2) a filename for tab-separated output file. 
argv <- commandArgs(trailingOnly=TRUE)
if (length(argv) != 2) {
    message("You must specify (1) a CellRanger filtered output directory, (2) an output filename!")
    quit(status=1)
}
cellranger_outdir <- argv[1]
outfile <- argv[2]

# Load data into seurat
umi <- Read10X(cellranger_outdir)
obj <- CreateSeuratObject(umi) %>% 
    PercentageFeatureSet(pattern="^mt-", col.name="percent.mt")

# Do a very basic standard analysis
mt_thresh <- 25   # %MT level above which we filter out the cells
num_pc <- 25      # GUESS at number of meaningful PCs
obj <- NormalizeData(obj) %>% FindVariableFeatures() %>% 
    subset(subset=percent.mt < mt_thresh) %>%
    ScaleData(vars.to.regress="percent.mt", verbose=FALSE) %>%
    RunPCA(verbose=FALSE, npcs=num_pc) %>% 
    RunUMAP(dims=1:num_pc)

# Run the doublet-finding algorithm
n_cells <- ncol(obj)
e_doublets <- round(n_cells*0.06)
# assume 6% doublet rate (generic but probably conservative 
# since often <6k cells/sample)

sweep.res.list <- paramSweep_v3(obj, PCs=1:num_pc, sct=FALSE)
sweep.stats <- summarizeSweep(sweep.res.list, GT=FALSE)
bcmvn <- find.pK(sweep.stats)
max_pK <- arrange(bcmvn, desc(BCmetric)) %>% 
    pull(pK) %>% as.character() %>% as.numeric() %>% head(1)

obj <- doubletFinder_v3(obj, PCs=1:num_pc, pN=0.25, pK=max_pK, 
    nExp=e_doublets, reuse.pANN=FALSE, sct=FALSE)
dat <- obj@meta.data %>% as.data.frame() %>%
    rownames_to_column("cell_id") %>%
    as_tibble() %>%
    select(cell_id, starts_with('pANN'), starts_with('DF.classifications'))
write_tsv(dat, path=outfile)
