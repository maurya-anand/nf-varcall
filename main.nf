#!/usr/bin/env nextflow

workflow {
    sample_ch = Channel
        .fromPath ( params.sample_sheet )
        .splitCsv ( header: true,sep: '\t' ) 
        .map { row->tuple(row.name, file(row.path)) }

    sample_ch.view()
}