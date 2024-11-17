process PBMM2 {
    tag "pbmm2"
    label "PBMM2"
    publishDir "$params.outdir/pbmm2/${id}", mode: 'copy'

    input:
    tuple val(id), path(fastq)
    each path(ref)

    output:
    tuple val(id), path("${id}.bam"), path("${id}.bam.bai"), emit: bam
    path "${id}.pbmm2.log", emit: log

    script:
    """
    pbmm2 align \
    --preset hifi \
    --sort \
    $ref \
    $fastq \
    ${id}.bam \
    --rg "@RG\\tID:${id}\\tSM:${id}" \
    --log-level INFO \
    --log-file ${id}.pbmm2.log
    """
}