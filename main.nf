#!/usr/bin/env nextflow

include { NANOPLOT } from './modules/nanoplot'
include { PBMM2 } from './modules/pbmm2'
include { DEEPVARIANT } from './modules/deepvariant'
include { MERGE_VCF } from './modules/merge_vcf'
include { VEP } from './modules/vep'
include { SUMMARY } from './modules/summary'
include { FILTER_VARIANTS } from './modules/filter_variants'
include { ALIGNMENT_SUMMARY } from './modules/alignment_summary'

workflow {
    sample_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true, sep: '\t')
        .map { row -> tuple(row.name, file(row.path)) }
    qc_results_ch = NANOPLOT(sample_ch)
    aligned_bam_ch = PBMM2(sample_ch)
    aln_summary_ch = ALIGNMENT_SUMMARY(aligned_bam_ch.bam)
    deepvariant_ch = DEEPVARIANT(aligned_bam_ch.bam)
    filtered_vcf_ch = FILTER_VARIANTS(deepvariant_ch.vcf)
    vcf_list_ch = filtered_vcf_ch.vcf.map { _id, vcf, _idx -> vcf }.collect()
    merged_vcf_ch = MERGE_VCF(vcf_list_ch)
    ann_vcf_ch = VEP(merged_vcf_ch.vcf)
    
    // qc_results_ch.qc.view()
    aln_summary_ch.summary.view()
    ann_vcf_ch.vep_vcf.view()
}
