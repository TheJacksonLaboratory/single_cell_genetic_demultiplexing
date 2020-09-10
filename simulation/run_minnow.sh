./minnow simulate --splatter-mode --g2t mouse_t2g.tsv \
    --inputdir splatter_mini/ --PCR 4 -r mouse_transcriptome.fa -e 0.01 -p 4 \
    -o TEST_OUT -w 737K-august-2016.txt \
    --useWeibull --testUniqness --uniq mouse_uniqueness_file_100.txt
