# nf-varcall

nf-varcall is a Nextflow pipeline for variant calling and annotation using PacBio Hi-Fi sequencing reads.

## Requirements

- Nextflow
- Docker

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
    --reference data/ref/Homo_sapiens.GRCh38.fa \
    --vep_cache_dir data/vep_cache/ \
    --vep_fork 4 \
    --outdir results_nf-varcall
```

## Input

- `--sample_sheet`: Path to the sample sheet TSV file. Example: `sample_sheet.tsv`
- `--reference`: Path to the reference genome FASTA file. Example: `data/ref/Homo_sapiens.GRCh38.fa`
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
