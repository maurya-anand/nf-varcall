process VEP {
    tag "vep"
    label "VEP"
    publishDir "${params.outdir}/vep/${id}", mode: 'copy'

    input:
    tuple val(id), path(vcf), path(vcf_idx)
    each path(ref)
    each path(vep_cache)

    output:
    path "${id}.PASS.NORM.VEP.vcf", emit: vep_vcf
    path "${id}.PASS.NORM.VEP.txt", emit: vep_txt

    script:
    """
    perl /opt/vep/src/ensembl-vep/vep --force_overwrite \
        --input_file ${vcf} \
        --vcf \
        --output_file ${id}.PASS.NORM.VEP.vcf \
        --stats_file ${id}.PASS.NORM.VEP.txt \
        --stats_text \
        --cache \
        --dir_cache ${vep_cache} \
        --merged \
        --fasta ${ref} \
        --fork ${params.vep_fork ?: 8} \
        --numbers --offline --hgvs --shift_hgvs 0 --terms SO --symbol \
        --sift b --polyphen b --total_length --ccds --canonical --biotype \
        --protein --xref_refseq --mane --pubmed --af --max_af --af_1kg --af_gnomadg \
        --custom file=${vep_cache}/clinvar.vcf.gz,short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN
    """
}
