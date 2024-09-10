#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.input_spectra = "README.md"

//This publish dir is mostly  useful when we want to import modules in other workflows, keep it here usually don't change it
params.publishdir = "$baseDir/nf_output"
TOOL_FOLDER = "$baseDir/bin"

process processDataPython {
    publishDir "$params.publishdir", mode: 'copy'

    conda "$TOOL_FOLDER/conda_env.yml"

    input:
    file input 

    output:
    file 'python_output.tsv'

    """
    python $TOOL_FOLDER/python_script.py $input python_output.tsv
    """
}

// TODO: This main will define the workflow that can then be imported, not really used right now, but can be
workflow Main{
    take:
    input_spectra
    publishDir

    main:
    data_ch = Channel.fromPath(params.input_spectra)
    
    // Outputting Python
    processDataPython(data_ch)

}

workflow {
    _ = Main(params.input_spectra, params.publishDir)

    // Alternatively we can put everyhthing in the main from the above right here
}
