#!/usr/bin/env nextflow

include { DATA_QC } from './modules/local/data_qc'
include { PBMM2 } from './modules/local/pbmm2'
include { DEEPVARIANT } from './modules/local/deepvariant'
include { MERGE_VCF } from './modules/local/merge_vcf'
include { VEP } from './modules/local/vep'
include { FILTER_VARIANTS } from './modules/local/filter_variants'
include { ALIGNMENT_SUMMARY } from './modules/local/alignment_summary'
include { REPORT } from './modules/local/report'

workflow {
    sample_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true, sep: '\t')
        .map { row -> tuple(row.name, file(row.path)) }
    qc_results_ch = DATA_QC(sample_ch)
    aligned_bam_ch = PBMM2(sample_ch)
    aln_summary_ch = ALIGNMENT_SUMMARY(aligned_bam_ch.bam)
    deepvariant_ch = DEEPVARIANT(aligned_bam_ch.bam)
    filtered_vcf_ch = FILTER_VARIANTS(deepvariant_ch.vcf)
    vcf_list_ch = filtered_vcf_ch.vcf.map { _id, vcf, _idx -> vcf }.collect()
    var_counts_ch = filtered_vcf_ch.stat.collect()
    merged_vcf_ch = MERGE_VCF(vcf_list_ch)
    ann_vcf_ch = VEP(merged_vcf_ch.vcf)
    qc_stats_ch = qc_results_ch.stats.collect()
    aln_cov_ch = aln_summary_ch.summary.flatMap { _id, flagstat, coverage, depth -> [flagstat, coverage, depth] }.collect()
    REPORT(qc_stats_ch, aln_cov_ch, ann_vcf_ch.vep_vcf, var_counts_ch)
}
