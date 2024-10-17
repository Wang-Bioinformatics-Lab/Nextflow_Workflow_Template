#!/usr/bin/env nextflow
nextflow.enable.dsl=2
nextflow.preview.output = true

include {Main as Module1} from './nf_workflow.nf'

params.foo = "Hola"
params.bar = "README.md"

//This publish dir is mostly  useful when we want to import modules in other workflows, keep it here usually don't change it
params.publish_dir = "./nf_output"
TOOL_FOLDER = "$moduleDir/bin"


process processExtra {
    // publishDir "$params.publish_dir", mode: 'copy' // it is better to use the publishDir in the workflow for better hierarchy management as the publishDir is the workflow can be variable

    conda "$TOOL_FOLDER/conda_env.yml"

    input:
    file input 
    val variable

    output:
    file 'outer/python_output_*.tsv'

    """
    mkdir outer
    python $TOOL_FOLDER/python_script.py $input $variable 'outer/python_output_${variable}.tsv'
    """
}

workflow Main{
    take:
    input_map

    main:
    input_map_copy_adjusted = input_map.getClass().newInstance(input_map)
    input_map_copy_adjusted.publish_dir = input_map.publish_dir + "/module1"
    res_module1 = Module1(input_map_copy_adjusted)

    data_ch = Channel.fromPath(input_map.bar).collect()
    var_ch = Channel.of("test1", "test2")
    results_extra = processExtra(data_ch, var_ch)


    combined_results = res_module1.concat(results_extra)

    results = combined_results.collectFile(name: "${input_map.publish_dir}/python_output2.tsv", newLine: false, keepHeader: true, skip: 1)

    publish:
    results_extra >> input_map.publish_dir

    emit:
    results
}

workflow {
    input_map = [foo: params.foo, bar:params.bar, publish_dir: params.publish_dir]
    _ = Main(input_map)
    
}

output{
    mode 'copy'
    // ignoreErrors true
}