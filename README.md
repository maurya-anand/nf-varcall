# nf-varcall

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
    --sample_sheet <sample_sheet.tsv>\
    --reference <reference.fa>\
    --vep_cache_dir <vep_cache_dir> \
    --vep_fork <threads> \
    [--outdir <output_directory>]
```

### Example

```bash
nextflow run main.nf \
    --sample_sheet data/sample_sheet.tsv \
    --reference data/ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
    --vep_cache_dir data/vep_cache/ \
    --vep_fork 4 \
    --outdir results_nf-varcall
```

## Input

- `--sample_sheet`: Path to the sample sheet TSV file. Example: `sample_sheet.tsv`
- `--reference`: Path to the reference genome FASTA file. Example: `data/ref/Homo_sapiens.GRCh38.dna.primary_assembly.fa`
- `--outdir`: Directory where outputs will be saved. Default: `results_nf-varcall`
- `--vep_cache_dir`: Path to the VEP cache directory for variant annotation.
- `--vep_fork`: Number of threads to use with the VEP tool.

### Sample Sheet Format

The sample sheet should be a tab-separated file with a header and the following columns:

- `name`: Sample identifier.
- `path`: Path to the FASTQ file for the sample.

Example `sample_sheet.tsv`:

```text
name    path
sample1 data/fastq/sample1.fastq.gz
sample2 data/fastq/sample2.fastq.gz
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
