process DATA_QC {
    tag "data_qc"
    label "DATA_QC"
    publishDir "${params.outdir}/data_qc/${id}", mode: 'copy'

    input:
    tuple val(id), path(data)

    output:
    path "*.{html,svg}", emit: qc
    path "${id}_*.txt", emit: stats

    script:
    def data_param = (data.toString().endsWith('.fastq') || data.toString().endsWith('.fastq.gz')) ? "--fastq" : "--ubam"
    """
    NanoPlot \
        ${data_param} ${data} \
        --format svg \
        --title ${id} \
        --prefix ${id}_ \
        --tsv_stats \
        --info_in_report
    seqkit stats -a -T ${data} > ${id}_SeqKitStats.txt
    """
}
