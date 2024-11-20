#!/usr/bin/env bash

VCF=$1
OUT=$2

samples=$(bcftools query -l ${VCF} | paste -sd '\t')
headers="chrom\tpos\tref\talt\tqual\tfilter\tVEP_Allele\tConsequence\tIMPACT\tSYMBOL\tGene\tFeature_type\tFeature\tBIOTYPE\tEXON\tINTRON\tHGVSc\tHGVSp\tcDNA_position\tCDS_position\tProtein_position\tAmino_acids\tCodons\tExisting_variation\tDISTANCE\tSTRAND\tFLAGS\tSYMBOL_SOURCE\tHGNC_ID\tCANONICAL\tMANE_SELECT\tMANE_PLUS_CLINICAL\tCCDS\tENSP\tRefSeq\tREFSEQ_MATCH\tSOURCE\tREFSEQ_OFFSET\tGIVEN_REF\tUSED_REF\tBAM_EDIT\tSIFT\tPolyPhen\tHGVS_OFFSET\tAF\tAFR_AF\tAMR_AF\tEAS_AF\tEUR_AF\tSAS_AF\tgnomADg_AF\tgnomADg_AFR_AF\tgnomADg_AMI_AF\tgnomADg_AMR_AF\tgnomADg_ASJ_AF\tgnomADg_EAS_AF\tgnomADg_FIN_AF\tgnomADg_MID_AF\tgnomADg_NFE_AF\tgnomADg_OTH_AF\tgnomADg_SAS_AF\tMAX_AF\tMAX_AF_POPS\tCLIN_SIG\tSOMATIC\tPHENO\tPUBMED\tClinVar\tClinVar_CLNSIG\tClinVar_CLNREVSTAT\tClinVar_CLNDN\t${samples}"
printf "%b\n" "$headers" > ${OUT}
bcftools +split-vep ${VCF} -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t%CSQ[\t%SAMPLE:%GT:%GQ:%DP:%AD:%VAF:%PL]\n' -d -A tab >>${OUT}
