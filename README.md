# nf-varcall

nf-varcall is a Nextflow pipeline for variant calling and annotation using PacBio Hi-Fi sequencing reads.

## Requirements

- Nextflow
- Docker

## Modules

The pipeline includes the following modules:

- `nanoplot`: A tool for visualization and quality control of nanopore sequencing data.
- `pbmm2`: An aligner for PacBio reads based on minimap2.
- `deepvariant`: A deep learning-based variant caller.

## Usage

To run the pipeline, execute the following command:

```bash
nextflow run main.nf --sample_sheet <sample_sheet.tsv> --reference <reference.fa> --outdir <output_directory>
```

### Example

```bash
nextflow run main.nf --sample_sheet data/sample_sheet.tsv --reference data/ref/genome.fa --outdir results_nf-varcall
```

## Input

- `--sample_sheet`: Path to the sample sheet TSV file. Example: `sample_sheet.tsv`
- `--reference`: Path to the reference genome FASTA file. Example: `data/ref/Homo_sapiens.GRCh38.fa`
- `--outdir`: Directory where outputs will be saved. Default: `results_nf-varcall`

### Sample Sheet Format

The sample sheet should be a tab-separated file with a header and the following columns:

- `name`: Sample identifier.
- `path`: Path to the FASTQ file for the sample.

Example `sample_sheet.tsv`:

```text
name    path
sample1 data/fastq/sample1.hifi.fastq.gz
sample2 data/fastq/sample2.hifi.fastq.gz
```

## Output

The pipeline stores results in the `results_nf-varcall` directory by default, which can be changed using the `--outdir` parameter. The outputs are organized into subdirectories corresponding to each module.

The following directory structure shows how the results are organized:

```bash
results_nf-varcall/
├── deepvariant     # Variant calling outputs (.vcf)
├── nanoqc          # Quality control reports
└── pbmm2           # Alignment results (.bam)
```

## Configuration

The pipeline can be customized via the `nextflow.config` file. Adjust settings such as inputs and process-level configurations as needed.

### Running with Docker

Ensure Docker is installed and running. The pipeline uses Docker containers specified in the `conf/process.config` for different processes in the pipeline.
