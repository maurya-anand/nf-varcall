process ALIGNMENT_SUMMARY {
    tag "alignment_summary"
    label "ALIGNMENT_SUMMARY"
    publishDir "${params.outdir}/alignment_summary/${id}", mode: 'copy'

    input:
    tuple val(id), path(bam), path(bai)

    output:
    tuple val(id), path("${id}.flagstat.tsv"), path("${id}.coverage.summary.tsv"), path("${id}*.depth.txt"), emit: summary

    script:
    """
    samtools flagstat ${bam} -O tsv > ${id}.flagstat.tsv
    ${params.targets_bed ? """
        getBamDepth --bed ${params.targets_bed} --bam ${bam} --thresholds 10,20,30,40,50,80,100 > ${id}.coverage.summary.tsv
    """ : """
        touch ${id}.coverage.summary.tsv ${id}.depth.txt
    """}
    """
}
