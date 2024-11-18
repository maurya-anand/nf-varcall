process MERGE_VCF {
    tag "merge_vcf"
    label "MERGE_VCF"
    publishDir "${params.outdir}/vcf_merge", mode: 'copy'

    input:
    path(vcf_list)

    output:
    tuple path("merged.vcf.gz"), path("merged.vcf.gz.tbi"), emit: vcf

    script:
    """
    for vcf in ${vcf_list}; do
        bgzip \${vcf}
        tabix -p vcf \${vcf}.gz
    done;
    bcftools merge --merge none *.vcf.gz -Oz -o merged.vcf.gz
    tabix -p vcf merged.vcf.gz
    """
}
