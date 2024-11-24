# nf-varcall

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/maurya-anand/nf-varcall/publish.yml?style=flat-square)&nbsp;&nbsp;
![GitHub release (with filter)](https://img.shields.io/github/v/release/maurya-anand/nf-varcall?style=flat-square)&nbsp;&nbsp;

nf-varcall is a Nextflow pipeline for variant calling and annotation using PacBio Hi-Fi sequencing reads.

## Requirements

- Nextflow
- Docker

## Setting Up Reference and VEP Annotation

To set up the Homo sapiens GRCh38 113 reference and VEP annotation, you can use the provided Makefile. This will download and prepare the necessary files.

Run the following command in the root directory of the project:

```bash
make
```

This will download the reference genome, VEP cache, and other required files, and place them in the following directories:

```bash
data/
├── bam
│   ├── NA02016.bam
│   └── NA07439.bam
├── ref
│   ├── Homo_sapiens.GRCh38.dna.chromosome.22.fa
│   └── vep_cache
│       └── homo_sapiens_merged
├── sample_sheet.tsv
└── targets-CYP2D6.bed
```

Make sure to update the `nextflow.config` accordingly to correctly point to the `reference`, `vep_cache_dir`, and `targets_bed`.

```groovy
params {
    // General parameters
    sample_sheet = "${baseDir}/data/sample_sheet.tsv"
    outdir = "${baseDir}/results_nf-varcall"

    // Reference data
    reference = "${baseDir}/data/ref/Homo_sapiens.GRCh38.dna.chromosome.22.fa"
    vep_cache_dir = "${baseDir}/data/ref/vep_cache"
    targets_bed = "${baseDir}/data/targets-CYP2D6.bed"

    // VEP parameters
    vep_fork = 12

    // VCF filtering parameters
    vcf_filter_QUAL = 30
    vcf_filter_DEPTH = 10
}
```

## Modules

The pipeline includes the following modules:

- `nanoplot`: A tool for visualization and quality control of long-read sequencing data.
- `pbmm2`: Aligns PacBio Hi-Fi reads to a reference genome.
- `deepvariant`: A deep learning-based variant caller.
- `VEP`: Variant Effect Predictor for annotating and predicting the effects of variants.

## Usage

To run the pipeline, execute the following command:

```bash
nextflow run main.nf \
    --sample_sheet data/sample_sheet.tsv \
    --reference data/ref/Homo_sapiens.GRCh38.dna.chromosome.22.fa \
    --vep_cache_dir data/ref/vep_cache/ \
    --targets_bed data/targets-CYP2D6.bed \
    --vep_fork 12 \
    --vcf_filter_QUAL 30 \
    --vcf_filter_DEPTH 10 \
    --outdir results_nf-varcall
```

## Input

- `--sample_sheet`: Path to the sample sheet TSV file. (required) Example: `data/sample_sheet.tsv`
- `--reference`: Path to the reference genome FASTA file. (required) Example: `data/ref/Homo_sapiens.GRCh38.dna.chromosome.22.fa`
- `--targets_bed`: Path to the BED file containing target regions. (optional) Example: `data/targets-CYP2D6.bed`
- `--outdir`: Directory where outputs will be saved. Default: `results_nf-varcall`
- `--vep_cache_dir`: Path to the VEP cache directory for variant annotation. (required)
- `--vep_fork`: Number of threads to use with the VEP tool.
- `--vcf_filter_QUAL`: Quality threshold for filtering variants in the VCF file. Variants with a quality score below this threshold will be filtered out. Default: `30`
- `--vcf_filter_DEPTH`: Depth threshold for filtering variants in the VCF file. Variants with a depth below this threshold will be filtered out. Default: `10`

### Sample Sheet Format

The sample sheet should be a tab-separated file with a header and the following columns:

- `name`: Sample identifier.
- `path`: The file path to the PacBio HiFi sequencing FASTQ or unaligned BAM file for the sample.

Example `sample_sheet.tsv`:

```text
name    path
sample1 data/bam/sample1.bam
sample2 data/bam/sample2.bam
sample3 data/fastq/sample3.fastq.gz
sample4 data/fastq/sample4.fastq.gz
```

## Output

The pipeline stores results in the `results_nf-varcall` directory by default, which can be changed using the `--outdir` parameter. The outputs are organized into subdirectories corresponding to each module.

The following directory structure shows how the results are organized:

```bash
results_nf-varcall/
├── data_qc
├── alignment
├── alignment_summary
├── variant_calling
├── variant_filtration
├── vcf_merge
├── variant_annotation
└── report
```

## Configuration

The pipeline can be customized via the `nextflow.config` file. Adjust settings such as inputs and process-level configurations as needed.

### Running with Docker

Ensure Docker is installed and running. The pipeline uses Docker containers specified in the `conf/process.config` for different processes in the pipeline.
