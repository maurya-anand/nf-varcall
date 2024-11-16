#!/usr/bin/env nextflow

include { NANOPLOT } from './modules/nanoplot'
include { PBMM2 } from './modules/pbmm2'

workflow {
    reference = Channel
        .fromPath(params.reference)

    sample_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true, sep: '\t')
        .map { row -> tuple(row.name, file(row.path)) }

    NANOPLOT(sample_ch)
    PBMM2(sample_ch, reference)
    PBMM2.out.bam.view()
}