process FILTER_VARIANTS {
    tag "filter_variants"
    label "FILTER_VARIANTS"
    publishDir "${params.outdir}/variant_filtration/${id}", mode: 'copy'

    input:
    tuple val(id), path(vcf), path(vcf_tbi)

    output:
    tuple val(id), path("${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz"), path("${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz.tbi"), emit: vcf
    path "${id}.variant.count.tsv", emit: stat

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
    variant_count=\$(zgrep -v "^#" "${vcf}" | wc -l)
    filtered_variant_count=\$(zgrep -v "^#" ${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf.gz | wc -l)
    printf "%s\t%d\t%d\n" "${id}" "\${variant_count}" "\${filtered_variant_count}" > ${id}.variant.count.tsv
    """
}
