process SUMMARY {
    tag "summary"
    label "SUMMARY"
    publishDir "${params.outdir}/summary/${vep_id}", mode: 'copy'

    input:
    path nanoqc
    tuple val(bam_id), path(bam), path(bai)
    path pbmm_log
    tuple val(vep_id), path(vep_vcf)
    each path(bed)

    output:
    path "*", emit: summary

    script:
    """
    getBamDepth \
        --bed ${bed} \
        --bam ${bam} \
        --thresholds 10,20,30,40,50,100 > ${bam_id}.depth.summary.tsv
    bcftools view \
        -i 'QUAL > ${params.vcf_filter_QUAL ?: 30} && DP >= ${params.vcf_filter_DEPTH ?: 10}' ${vep_vcf} | \
        bedtools intersect \
        -header \
        -a ${vep_vcf} \
        -b ${bed} \
        -wa > ${vep_id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf
    convert_vep_vcf_to_tsv.sh \
        ${vep_id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.vcf \
        ${vep_id}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.tsv
    """
}
