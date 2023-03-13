#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.input = "README.md"

TOOL_FOLDER = "$baseDir/bin"

process processData {
    publishDir "./nf_output", mode: 'copy'

    conda "$TOOL_FOLDER/conda_env.yml"

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