#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// 
params.input_spectra = "$baseDir/data/"

//This publish dir is mostly  useful when we want to import modules in other workflows, keep it here usually don't change it
params.publishdir = "$launchDir"
TOOL_FOLDER = "$moduleDir/bin"
MODULES_FOLDER = "$TOOL_FOLDER/NextflowModules"

// GNPS2 Boiler Plate
params.task = "" // This is the GNPS2 task if it is necessary

// COMPATIBILITY NOTE: The following might be necessary if this workflow is being deployed in a slightly different environemnt
// checking if outdir is defined,
// if so, then set publishdir to outdir
if (params.outdir) {
    _publishdir = params.outdir
}
else{
    _publishdir = params.publishdir
}

// Augmenting with nf_output
_publishdir = "${_publishdir}/nf_output"

// A lot of useful modules are already implemented and added to the nextflow modules, you can import them to use
// the publishdir is a key word that we're using around all our modules to control where the output files will be saved
include {summaryLibrary} from "$MODULES_FOLDER/nf_library_search_modules.nf" addParams(publishdir: _publishdir)

process processDataPython {
    /* This is a sample process that runs a python script.

    For each process, you can specify the publishDir, which is the directory where the output files will be saved.
    You can also specify the conda environment that will be used to run the process.
    The input and output blocks define the input and output files for the process.
    The script block contains the command that will be run in the process.
    */

    publishDir "$_publishdir", mode: 'copy'

    conda "$TOOL_FOLDER/conda_env.yml"

    input:
    file input 

    output:
    file 'python_output.tsv'

    script:
    """
    python $TOOL_FOLDER/python_script.py --input_filename $input --output_filename python_output.tsv
    """
}

workflow Main{
    // -------  -------
    /* 
    For each named workflow, add 'take' and 'main' blocks.

    --take--
    For the take block, you can specify the input parameters that will be passed to the workflow.
    Another option instead of passing all the values, is to use a map, which is a dictionary of key-value pairs.

    --main--
    The main block is where the workflow is defined. You can call other processes and workflows from here.

    --emit--
    This is an optional block and if you are new to nextflow you can ignore it.
    This is can be useful in future generations of nextflow, replacing the need for the 'publishDir' directive.
    */

    take: 
    input_map

    main:
    libraries_ch = Channel.fromPath(input_map.input_spectra + "/*.mgf" )
    // summaryLibrary(libraries_ch)
    library_summary_ch = summaryLibrary(libraries_ch)
    processDataPython(library_summary_ch)

    emit:
    library_summary_ch // doesn't need .out as it is already the output of summaryLibrary, assigned to library_summary_ch
    py_out = processDataPython.out
}

workflow {
    /* 
    The input map is created to reduce the dependency of the other workflows to the `params`
    */
    input_map = [
        input_spectra: params.input_spectra
    ]
    out = Main(input_map)
    out[0].view() // library_summary_ch
    out.py_out.view()
}
