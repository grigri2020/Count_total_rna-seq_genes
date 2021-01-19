#FROM https://kb.10xgenomics.com/hc/en-us/articles/360023793031-How-can-I-convert-the-feature-barcode-matrix-from-Cell-Ranger-3-to-a-CSV-file-
# Print line number along with contents of barcodes.tsv.gz and genes.tsv.gz 
zcat barcodes.tsv.gz | awk -F "\t" 'BEGIN { OFS = "," }; {print NR,$1}' | sort -t, -k 1b,1 > numbered_barcodes.csv
zcat features.tsv.gz | awk -F "\t" 'BEGIN { OFS = "," }; {print NR,$1,$2,$3}' | sort -t, -k 1b,1 > numbered_features.csv

# Skip the header lines and sort matrix.mtx.gz
zcat matrix.mtx.gz | tail -n +4 | awk -F " " 'BEGIN { OFS = "," }; {print $1,$2,$3}' | sort -t, -k 1b,1 > feature_sorted_matrix.csv
zcat matrix.mtx.gz | tail -n +4 | awk -F " " 'BEGIN { OFS = "," }; {print $1,$2,$3}' | sort -t, -k 2b,2 > barcode_sorted_matrix.csv

# Use join to replace line number with barcodes and genes
join -t, -1 1 -2 1 numbered_features.csv feature_sorted_matrix.csv | cut -d, -f 2,3,4,5,6 | sort -t, -k 4b,4 | join -t, -1 1 -2 4 numbered_barcodes.csv - | cut -d, -f 2,3,4,5,6 > final_matrix.csv

# Remove temp files
rm -f barcode_sorted_matrix.csv feature_sorted_matrix.csv numbered_barcodes.csv numbered_features.csv
