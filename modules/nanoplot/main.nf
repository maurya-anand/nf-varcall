process NANOPLOT {
    tag "nanoqc"
    label "NanoQC"
    publishDir "${params.outdir}/nanoqc/${id}", mode: 'copy'

    input:
    tuple val(id), path(fastq)

    output:
    path "*", emit: qc

    script:
    """
    NanoPlot --fastq ${fastq} --format svg --title ${id}
    """
}
