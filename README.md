# nf-varcall

![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/maurya-anand/nf-varcall/publish.yml?style=flat-square)&nbsp;&nbsp;
![GitHub release (with filter)](https://img.shields.io/github/v/release/maurya-anand/nf-varcall?style=flat-square)&nbsp;&nbsp;
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14216029.svg)](https://doi.org/10.5281/zenodo.14216029)

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

## Refrences

- Application note HiFi amplicon sequencing for pharmacogenetics CYP2D6. (2022, October 7). PacBio. https://pacbio.cn/literature/application-note-hifi-amplicon-sequencing-for-pharmacogenetics-cyp2d6/
- Danecek, P., Bonfield, J. K., Liddle, J., Marshall, J., Ohan, V., Pollard, M. O., Whitwham, A., Keane, T., McCarthy, S. A., Davies, R. M., & Li, H. (2021). Twelve years of SAMtools and BCFtools. GigaScience, 10(2). https://doi.org/10.1093/gigascience/giab008
- De Coster, W., & Rademakers, R. (2023). NanoPack2: population-scale evaluation of long-read sequencing data. Bioinformatics, 39(5), btad311.
- Di Tommaso, P., Chatzou, M., Floden, E. W., Barja, P. P., Palumbo, E., & Notredame, C. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology, 35(4), 316–319.
- Dirk Merkel. 2014. Docker: lightweight Linux containers for consistent development and deployment. Linux J. 2014, 239, Article 2 (March 2014)
- GitHub - mamba-org/mamba: The Fast Cross-Platform Package Manager. (n.d.). GitHub. Retrieved November 25, 2024, from https://github.com/mamba-org/mamba
- GitHub - PacificBiosciences/pbmm2: A minimap2 frontend for PacBio native data formats. (n.d.). GitHub. Retrieved November 25, 2024, from https://github.com/PacificBiosciences/pbmm2
- Grüning, B., Dale, R., Sjödin, A., Chapman, B. A., Rowe, J., Tomkins-Tinch, C. H., Valieris, R., Köster, J., & Bioconda Team. (2018). Bioconda: sustainable and comprehensive software distribution for the life sciences. Nature Methods, 15(7), 475–476.
- Landrum, M. J., Lee, J. M., Riley, G. R., Jang, W., Rubinstein, W. S., Church, D. M., & Maglott, D. R. (2014). ClinVar: public archive of relationships among sequence variation and human phenotype. Nucleic Acids Research, 42(Database issue), D980–D985.
- McLaren, W., Gil, L., Hunt, S. E., Riat, H. S., Ritchie, G. R. S., Thormann, A., Flicek, P., & Cunningham, F. (2016). The Ensembl Variant Effect Predictor. Genome Biology, 17(1), 1–14.
- Poplin, R., Chang, P.-C., Alexander, D., Schwartz, S., Colthurst, T., Ku, A., Newburger, D., Dijamco, J., Nguyen, N., Afshar, P. T., Gross, S. S., Dorfman, L., McLean, C. Y., & DePristo, M. A. (2018). A universal SNP and small-indel variant caller using deep neural networks. Nature Biotechnology, 36(10), 983–987.
- Quinlan, A. R., & Hall, I. M. (2010). BEDTools: a flexible suite of utilities for comparing genomic features. Bioinformatics (Oxford, England), 26(6), 841–842.
- Shen, W., Le, S., Li, Y., & Hu, F. (2016). SeqKit: A Cross-Platform and Ultrafast Toolkit for FASTA/Q File Manipulation. PLOS ONE, 11(10), e0163962.
