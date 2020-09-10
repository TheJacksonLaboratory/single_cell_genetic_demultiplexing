library(splatter)
set.seed(1)

num_genes <- 100
num_cells <- 8
sim <- splatSimulate( 
	nGenes=num_genes, 
	batchCells=num_cells, 
	verbose = FALSE
)
out_dir <- "splatter_mini"
write.table(rownames(sim), file= file.path(out_dir, "quants_mat_rows.txt"), quote=FALSE, col.names=FALSE, row.names=FALSE)
write.table(colnames(sim), file= file.path(out_dir, "quants_mat_cols.txt"), quote=FALSE, col.names=FALSE, row.names=FALSE)
write.table(counts(sim), file= file.path(out_dir, "quants_mat.csv"), quote=FALSE, col.names=FALSE, row.names=FALSE, sep=",")  
