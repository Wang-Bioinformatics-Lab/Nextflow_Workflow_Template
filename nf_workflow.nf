#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.input = "README.md"

TOOL_FOLDER = "$baseDir/bin"

process processData {
    publishDir "./nf_output", mode: 'copy'

    conda "my_env" // using a named conda environment

    input:
    file input 

    output:
    file 'python_output.tsv'
    file 'R_output.txt'
    file 'rpy2_output.txt'
    """
    python $TOOL_FOLDER/script.py $input python_output.tsv
    Rscript  $TOOL_FOLDER/R_script.R
    python $TOOL_FOLDER/rpy2_script.py
    """
}

workflow {
    data = Channel.fromPath(params.input)
    processData(data)
}