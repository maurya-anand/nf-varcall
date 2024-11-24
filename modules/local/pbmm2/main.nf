process PBMM2 {
    tag "pbmm2"
    label "PBMM2"
    publishDir "${params.outdir}/alignment/${id}", mode: 'copy'

    input:
    tuple val(id), path(data)

    output:
    tuple val(id), path("${id}.aligned.bam"), path("${id}.aligned.bam.bai"), emit: bam
    path "${id}.pbmm2.log", emit: log

    script:
    def rg_param = (data.toString().endsWith('.fastq') || data.toString().endsWith('.fastq.gz')) ? "--rg \"@RG\\tID:${id}\\tSM:${id}\"" : ""
    """
    pbmm2 align \
    --preset hifi \
    --sort \
    ${rg_param} \
    --log-level INFO \
    --log-file ${id}.pbmm2.log \
    ${params.reference} \
    ${data} \
    ${id}.aligned.bam
    """
}