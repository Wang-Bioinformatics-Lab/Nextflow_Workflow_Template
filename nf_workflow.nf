#!/usr/bin/env nextflow

params.input = "README.md"

// Workflow Boiler Plate
params.OMETALINKING_YAML = "flow_filelinking.yaml"
params.OMETAPARAM_YAML = "job_parameters.yaml"

TOOL_FOLDER = "$baseDir/bin"

process processData {
    publishDir "./nf_output", mode: 'copy'

    conda "$TOOL_FOLDER/conda_env.yml"

    input:
    file input from Channel.fromPath(params.input)

    output:
    file 'output.tsv' into records_ch

    """
    python $TOOL_FOLDER/script.py $input output.tsv
    """
}