#!/usr/bin/env nextflow

include { NANOPLOT } from './modules/nanoplot'

workflow {
    sample_ch = Channel
        .fromPath ( params.sample_sheet )
        .splitCsv ( header: true,sep: '\t' ) 
        .map { row->tuple(row.name, file(row.path)) }

    nanoqc_ch = NANOPLOT(sample_ch)

}