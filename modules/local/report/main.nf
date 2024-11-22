process REPORT {
    tag "report"
    label "REPORT"
    publishDir "${params.outdir}/report/", mode: 'copy'

    input:
    path qc_stats_ch
    path aln_cov_ch
    path ann_vcf_ch
    path var_counts

    output:
    path "*", emit: report

    script:
    """
    convert_vep_vcf_to_tsv.sh \
        ${ann_vcf_ch} \
        ${ann_vcf_ch}.PASS.NORM.VEP.ANN.FILTERED.ONTARGET.tsv
    report ${params.sample_sheet} ${params.outdir}
    """
}
