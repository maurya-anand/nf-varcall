process DEEPVARIANT {
    tag "deepvariant"
    label "DeepVariant"
    publishDir "${params.outdir}/deepvariant/${id}", mode: 'copy'

    input:
    tuple val(id), path(bam), path(bai)

    output:
    tuple val(id), path("${id}.PASS.NORM.vcf.gz"), path("${id}.PASS.NORM.vcf.gz.tbi"), emit: vcf
    path "*.html", emit: html

    script:
    """
    samtools faidx ${params.reference} -o ${params.reference}.fai

    /opt/deepvariant/bin/run_deepvariant \
    --model_type PACBIO \
    --num_shards 12 \
    --ref ${params.reference} \
    --reads ${bam} \
    --output_vcf ${id}.vcf.gz

    bcftools view -f PASS ${id}.vcf.gz -Oz -o ${id}.PASS.vcf.gz

    bcftools norm ${id}.PASS.vcf.gz -f ${params.reference} -m -any -Oz -o ${id}.PASS.NORM.vcf.gz

    tabix -p vcf ${id}.PASS.NORM.vcf.gz
    """
}
