#!/usr/bin/env nextflow

params.input = "README.md"

TOOL_FOLDER = "$baseDir/bin"

process process {
    //conda '/path/to/an/existing/env/directory'
    //container 'image_name_1'

    publishDir "./nf_output", mode: 'copy'

    input:
    file input from Channel.fromPath(params.input)

    output:
    file 'output.tsv' into records_ch

    """
    python $TOOL_FOLDER/script.py $input output.tsv
    """
}