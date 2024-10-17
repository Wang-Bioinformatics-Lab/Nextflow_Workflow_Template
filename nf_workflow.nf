#!/usr/bin/env nextflow
// tested on N E X T F L O W   ~  version 24.04.4
nextflow.enable.dsl=2
nextflow.preview.output = true

params.foo = "Hello"
params.bar = "README.md"

//This publish dir is mostly  useful when we want to import modules in other workflows, keep it here usually don't change it
params.publish_dir = "./nf_output"
TOOL_FOLDER = "$moduleDir/bin"

process processDataPython {
    // publishDir "$params.publish_dir", mode: 'copy' // it is better to use the publishDir in the workflow for better hierarchy management as the publishDir is the workflow can be variable

    conda "$TOOL_FOLDER/conda_env.yml"

    input:
    file input 
    val variable

    output:
    file 'python_output.tsv'

    """
    python $TOOL_FOLDER/python_script.py $input $variable python_output.tsv
    """
}

// TODO: This main will define the workflow that can then be imported, not really used right now, but can be
workflow Main{
    take:
    input_map

    main:
    data_ch = Channel.fromPath(input_map.bar)
    var_ch = Channel.of(input_map.foo)
    
    // Outputting Python
    results = processDataPython(data_ch, var_ch)

    publish:
    results >> input_map.publish_dir

    emit:
    results
}

workflow {
    input_map = [foo: params.foo, bar: params.bar, publish_dir: '.']
    _ = Main(input_map)
    // Alternatively we can put everyhthing in the main from the above right here
}

output{
    directory params.publish_dir
    mode 'copy'
    // ignoreErrors true
}