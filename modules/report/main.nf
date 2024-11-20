process REPORT {
    tag "report"
    label "REPORT"
    publishDir "${params.outdir}/report/", mode: 'copy'

    input:
    path qc_stats_ch
    path aln_cov_ch
    path ann_vcf_ch

    output:
    path "*", emit: report

    script:
    """
    convert_vep_vcf_to_tsv.sh \
        ${ann_vcf_ch} \
        ${ann_vcf_ch}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.tsv
    """
}
