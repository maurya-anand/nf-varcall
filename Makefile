BASE_DIR := $(shell pwd)
REF_DIR := $(BASE_DIR)/data/ref
VEP_CACHE_DIR := $(REF_DIR)/vep_cache
BAM_DIR := $(BASE_DIR)/data/bam

BED_FILE = $(BASE_DIR)/data/targets-CYP2D6.bed
SAMPLE1 = $(BAM_DIR)/NA02016.bam
SAMPLE2 = $(BAM_DIR)/NA07439.bam
SAMPLE_SHEET = $(BASE_DIR)/data/sample_sheet.tsv

VEP_URL = https://ftp.ensembl.org/pub/release-113/variation/indexed_vep_cache/homo_sapiens_merged_vep_113_GRCh38.tar.gz
VEP_FILE = $(VEP_CACHE_DIR)/homo_sapiens_merged_vep_113_GRCh38.tar.gz

CLIN_VCF_URL = https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz
CLIN_VCF_IDX_URL = https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz.tbi
VCF_FILE = $(VEP_CACHE_DIR)/clinvar.vcf.gz
VCF_IDX_FILE = $(VEP_CACHE_DIR)/clinvar.vcf.gz.tbi

FASTA_URL = https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.22.fa.gz
FASTA_FILE = $(REF_DIR)/Homo_sapiens.GRCh38.dna.chromosome.22.fa.gz
FASTA_UNZIPPED = $(REF_DIR)/Homo_sapiens.GRCh38.dna.chromosome.22.fa

SAMPLE1_BAM = https://downloads.pacbcloud.com/public/dataset/HiFi_amplicon_CYP2D6/downsampled/NA02016.bam
SAMPLE2_BAM = https://downloads.pacbcloud.com/public/dataset/HiFi_amplicon_CYP2D6/downsampled/NA07439.bam

all: $(BED_FILE) $(FASTA_UNZIPPED) $(VEP_CACHE_DIR)/.done $(SAMPLE1) $(SAMPLE2) $(SAMPLE_SHEET)

$(SAMPLE1):
	mkdir -p $(BAM_DIR)
	[ -f $(SAMPLE1) ] || curl -o $(SAMPLE1) $(SAMPLE1_BAM)

$(SAMPLE2):
	mkdir -p $(BAM_DIR)
	[ -f $(SAMPLE2) ] || curl -o $(SAMPLE2) $(SAMPLE2_BAM)

$(BED_FILE):
	mkdir -p $(REF_DIR)
	printf "22\t42126499\t42130865\tCYP2D6:ENSG00000100197\t.\t-\n" > $@

$(VEP_CACHE_DIR)/.done:
	[ -d $(VEP_CACHE_DIR) ] || mkdir -p $(VEP_CACHE_DIR)
	[ -f $(VEP_FILE) ] || curl -o $(VEP_FILE) $(VEP_URL)
	[ -f $(VCF_FILE) ] || curl -o $(VCF_FILE) $(CLIN_VCF_URL)
	[ -f $(VCF_IDX_FILE) ] || curl -o $(VCF_IDX_FILE) $(CLIN_VCF_IDX_URL)
	[ -f $(VEP_CACHE_DIR)/.done ] || (tar xzf $(VEP_FILE) -C $(VEP_CACHE_DIR) && rm $(VEP_FILE) && touch $(VEP_CACHE_DIR)/.done)

$(FASTA_UNZIPPED):
	[ -f $(FASTA_FILE) ] || curl -o $(FASTA_FILE) $(FASTA_URL)
	[ -f $(FASTA_UNZIPPED) ] || gzip -d $(FASTA_FILE)

$(SAMPLE_SHEET):
	printf "name\tpath\n" > $@
	printf "NA02016\t%s\n" "$(SAMPLE1)" >> $@
	printf "NA07439\t%s\n" "$(SAMPLE2)" >> $@

clean:
	rm -f $(BED_FILE) $(VEP_FILE) $(FASTA_FILE)
	rm -rf $(VEP_CACHE_DIR)
	rm -f $(FASTA_UNZIPPED)

.PHONY: clean