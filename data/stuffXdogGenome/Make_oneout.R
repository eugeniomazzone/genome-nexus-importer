#!/usr/bin/env Rscript --vanilla

# This script will download various data tables from Ensembl BioMart,
# which serves as input for the Genome Nexus Import pipeline.

library(biomaRt)

#args = commandArgs(trailingOnly=TRUE)
args = c('canis_lupus_familiaris', 'cfa_ensembl104/export/', 'cfa')
# set working dir to the correct genome/version input dir
species <- args[1]
path <- args[2]
genome_build <- args[3]

if (genome_build == "grch37") {
  host_url = "https://grch37.ensembl.org"
} else if (genome_build == "cfa"){
  host_url = "https://may2021.archive.ensembl.org"
}else {
  host_url = "https://www.ensembl.org"
}

stopifnot(species %in% c('homo_sapiens', 'mus_musculus', 'canis_lupus_familiaris'))

# set species to short name for biomart
species <- ifelse(species=='homo_sapiens', 'hsapiens', ifelse(species=='mus_musculus', 'mmusculus', 'clfamiliaris'))

# select mart
# listEnsembl()

ensembl <- useMart(biomart='ensembl', host=host_url, dataset=paste0(species, '_gene_ensembl'))

# list datasets and attributes
# listDatasets(ensembl)
# listAttributes(ensembl)
prova <- getBM(attributes=c('ensembl_gene_id', 'ensembl_transcript_id','uniprot_gn_symbol','entrezgene_id', 'chromosome_name', 'description'), mart=ensembl)

df <- data.frame(hgnc_symbol=prova$uniprot_gn_symbol,
ensembl_canonical_gene=prova$ensembl_gene_id,
ensembl_canonical_transcript=prova$ensembl_transcript_id,
genome_nexus_canonical_transcript=prova$ensembl_transcript_id,
uniprot_canonical_transcript=prova$ensembl_transcript_id,
mskcc_canonical_transcript=prova$ensembl_transcript_id,
hgnc_id= prova$ensembl_gene_id,
approved_name= prova$description,
locus_group= "Gene",
locus_type="protein coding gene",
entrez_gene_id= prova$entrezgene_id,
chromosome= prova$chromosome_name,
status="" ,
location_sortable="" ,
synonyms="" ,
alias_name="" ,
previous_symbols="" ,
prev_name="" ,
gene_family="" ,
gene_family_id="" ,
date_approved_reserved="" ,
date_symbol_changed="" ,
date_name_changed="" ,
date_modified="" ,
vega_id="" ,
ucsc_id="" ,
accession_numbers="" ,
refseq_ids="" ,
ccds_id="" ,
uniprot_id="" ,
pubmed_id="" ,
mgd_id="" ,
rgd_id="" ,
lsdb="" ,
cosmic="" ,
omim_id="" ,
mirbase="" ,
homeodb="" ,
snornabase="" ,
bioparadigms_slc="" ,
orphanet="" ,
pseudogene.org="" ,
horde_id="" ,
merops="" ,
imgt="" ,
iuphar="" ,
kznf_gene_catalog="" ,
'mamit-trnadb'="" ,
cd="" ,
lncrnadb="" ,
enzyme_id="" ,
intermediate_filament_db="" ,
rna_central_ids="" )

write.table(df, paste0(path, '/ensembl_biomart_canonical_transcripts_per_hgnc.txt'), na='', sep='\t', quote=FALSE, row.names=FALSE)
