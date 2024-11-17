#!/usr/bin/env nextflow

include { NANOPLOT } from './modules/nanoplot'
include { PBMM2 } from './modules/pbmm2'
include { DEEPVARIANT } from './modules/deepvariant'
include { VEP } from './modules/vep'
include { SUMMARY } from './modules/summary'

workflow {
    reference = Channel.fromPath(params.reference)
    vep_cache_dir = Channel.fromPath(params.vep_cache_dir, type: 'dir')
    sample_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true, sep: '\t')
        .map { row -> tuple(row.name, file(row.path)) }
    targets = Channel.fromPath(params.targets_bed)
    NANOPLOT(sample_ch)
    PBMM2(sample_ch, reference)
    deepvariant_ch = DEEPVARIANT(PBMM2.out.bam, reference)
    VEP(deepvariant_ch.vcf, reference, vep_cache_dir)
    SUMMARY(NANOPLOT.out.qc, PBMM2.out.bam, PBMM2.out.log, VEP.out.vep_vcf, targets)
}
