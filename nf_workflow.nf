#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.input = "README.md"

TOOL_FOLDER = "$baseDir/bin"

process processDataPython {
    publishDir "./nf_output", mode: 'copy'

    conda "$TOOL_FOLDER/conda_env.yml"

    input:
    file input 

    output:
    file 'python_output.tsv'

    """
    python $TOOL_FOLDER/python_script.py $input python_output.tsv
    """
}

process processDataR {
    publishDir "./nf_output", mode: 'copy'

    conda "$TOOL_FOLDER/conda_env_r.yml"

    input:
    file input 

    output:
    file 'R_output.txt'
    file 'rpy2_output.txt'

    """
    Rscript  $TOOL_FOLDER/R_script.R
    python $TOOL_FOLDER/rpy2_script.py
    """
}

workflow {
    data = Channel.fromPath(params.input)
    
    // Outputting Python
    processDataPython(data)

    // Outputting R
    processDataR(data)
}