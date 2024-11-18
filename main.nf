#!/usr/bin/env nextflow

include { NANOPLOT } from './modules/nanoplot'
include { PBMM2 } from './modules/pbmm2'
include { DEEPVARIANT } from './modules/deepvariant'
include { VEP } from './modules/vep'
include { SUMMARY } from './modules/summary'

workflow {
    reference = Channel.fromPath(params.reference)
    sample_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true, sep: '\t')
        .map { row -> tuple(row.name, file(row.path)) }
    qc_results_ch = NANOPLOT(sample_ch)
    aligned_bam_ch = PBMM2(sample_ch, reference)
    deepvariant_ch = DEEPVARIANT(aligned_bam_ch.bam, reference)
    ann_vcf_ch = VEP(deepvariant_ch.vcf, reference)
    SUMMARY(qc_results_ch.qc, aligned_bam_ch.bam, aligned_bam_ch.log, ann_vcf_ch.vep_vcf)
}
