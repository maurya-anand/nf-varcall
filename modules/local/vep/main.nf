process VEP {
    tag "vep"
    label "VEP"
    publishDir "${params.outdir}/variant_annotation/", mode: 'copy'

    input:
    tuple path(vcf), path(vcf_idx)

    output:
    path("MERGED.PASS.NORM.VEP.vcf"), emit: vep_vcf
    path("MERGED.PASS.NORM.VEP.txt"), emit: vep_txt

    script:
    """
    perl /opt/vep/src/ensembl-vep/vep --force_overwrite \
        --input_file ${vcf} \
        --vcf \
        --output_file MERGED.PASS.NORM.VEP.vcf \
        --stats_file MERGED.PASS.NORM.VEP.txt \
        --stats_text \
        --cache \
        --dir_cache ${params.vep_cache_dir} \
        --merged \
        --fasta ${params.reference} \
        --fork ${params.vep_fork ?: 8} \
        --numbers --offline --hgvs --shift_hgvs 0 --terms SO --symbol \
        --sift b --polyphen b --total_length --ccds --canonical --biotype \
        --protein --xref_refseq --mane --pubmed --af --max_af --af_1kg --af_gnomadg \
        --custom file=${params.vep_cache_dir}/clinvar.vcf.gz,short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN
    """
}
