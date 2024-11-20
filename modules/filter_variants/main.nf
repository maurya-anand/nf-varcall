process FILTER_VARIANTS {
    tag "filter_variants"
    label "FILTER_VARIANTS"
    publishDir "${params.outdir}/variant_filtration/${id}", mode: 'copy'

    input:
    tuple val(id), path(vcf), path(vcf_tbi)

    output:
    tuple val(id), path("${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz"), path("${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz.tbi"), emit: vcf

    script:
    """
    bcftools view \
        -i 'QUAL > ${params.vcf_filter_QUAL ?: 30} && DP >= ${params.vcf_filter_DEPTH ?: 10}' ${vcf} | \
        bedtools intersect \
        -header \
        -a ${vcf} \
        -b ${params.targets_bed} \
        -wa > ${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf
    bgzip -c ${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf > ${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz
    tabix -p vcf ${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz
    """
}
