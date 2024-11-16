process PBMM2 {
    tag "pbmm2"
    label "PBMM2"
    publishDir "results/pbmm2/${id}", mode: 'copy'

    input:
    tuple val(id), path(fastq)
    each path(ref)

    output:
    path "*.bam", emit: bam
    path "*.bai", emit: bai
    path "*.log", emit: log

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