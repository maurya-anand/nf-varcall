# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2024-11-24

### Added

- Initial release of `nf-varcall`, a Nextflow-based pipeline for variant calling and annotation using PacBio Hi-Fi sequencing reads.
- Modules: `data_qc`, `pbmm2`, `deepvariant`, `filter_variants`, `merge_vcf`, `vep`, `alignment_summary`, `report`.
- Configuration: Support for Docker containers to ensure reproducibility.
- `README.md` for usage instructions, input/output specifications, and configuration options.
- `Makefile` to setup the VEP cache (`homo_sapiens_merged_vep_113_GRCh38`) and example data.
