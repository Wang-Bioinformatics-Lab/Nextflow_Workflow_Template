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
    file 'output.tsv'

    """
    python $TOOL_FOLDER/script.py $input output.tsv
    """
}

workflow {
    data = Channel.fromPath(params.input)
    processData(data)
}