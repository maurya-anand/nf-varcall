process DATA_QC {
    tag "data_qc"
    label "DATA_QC"
    publishDir "${params.outdir}/data_qc/${id}", mode: 'copy'

    input:
    tuple val(id), path(fastq)

    output:
    path "*.{html,svg}", emit: qc
    path "${id}_*.txt", emit: stats

    script:
    """
    NanoPlot \
        --fastq ${fastq} \
        --format svg \
        --title ${id} \
        --prefix ${id}_ \
        --tsv_stats \
        --info_in_report
    seqkit stats -a -T ${fastq} > ${id}_SeqKitStats.txt
    """
}
