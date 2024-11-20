process NANOPLOT {
    tag "nanoqc"
    label "NanoQC"
    publishDir "${params.outdir}/nanoqc/${id}", mode: 'copy'

    input:
    tuple val(id), path(fastq)

    output:
    path "*.{html,svg}", emit: qc
    path "${id}_NanoStats.txt", emit: stats

    script:
    """
    NanoPlot \
        --fastq ${fastq} \
        --format svg \
        --title ${id} \
        --prefix ${id}_ \
        --tsv_stats \
        --info_in_report
    """
}
