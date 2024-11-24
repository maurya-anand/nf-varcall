process FILTER_VARIANTS {
    tag "filter_variants"
    label "FILTER_VARIANTS"
    publishDir "${params.outdir}/variant_filtration/${id}", mode: 'copy'

    input:
    tuple val(id), path(vcf), path(vcf_tbi)

    output:
    tuple val(id), path("${id}.PASS.NORM.VEP.ANN.FILTERED*.vcf.gz"), path("${id}.PASS.NORM.VEP.ANN.FILTERED*.vcf.gz.tbi"), emit: vcf
    path "${id}.variant.count.tsv", emit: stat

    script:
    def outfile = params.targets_bed ? "${id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf" : "${id}.PASS.NORM.VEP.ANN.FILTERED.vcf"
    """
    ${params.targets_bed ? """
        bcftools view \\
            -i 'QUAL > ${params.vcf_filter_QUAL ?: 30} && DP >= ${params.vcf_filter_DEPTH ?: 10}' ${vcf} | \\
        bedtools intersect \\
            -header \\
            -a ${vcf} \\
            -b ${params.targets_bed} \\
            -wa > ${outfile}
    """ : """
        bcftools view \\
            -i 'QUAL > ${params.vcf_filter_QUAL ?: 30} && DP >= ${params.vcf_filter_DEPTH ?: 10}' ${vcf} > ${outfile}
    """}
    bgzip -c ${outfile} > ${outfile}.gz
    tabix -p vcf ${outfile}.gz
    variant_count=\$(zgrep -v "^#" "${vcf}" | wc -l)
    filtered_variant_count=\$(zgrep -v "^#" ${outfile}.gz | wc -l)
    printf "%s\t%d\t%d\n" "${id}" "\${variant_count}" "\${filtered_variant_count}" > ${id}.variant.count.tsv
    """
}
