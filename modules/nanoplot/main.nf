process NANOPLOT {
    tag "nanoqc"
    label "NanoQC"
    publishDir "results/nanoqc"
    
    input:
    path fastq
    
    output:
    path "*", emit: qc
    
    script:
    """
    NanoPlot --fastq ${fastq} --format svg --title ${fastq.simpleName}
    """
}