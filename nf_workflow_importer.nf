#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include {Main as Module1} from './nf_workflow.nf'

params.input_spectra = "README.md"

//This publish dir is mostly  useful when we want to import modules in other workflows, keep it here usually don't change it
params.publishDir = "$baseDir/nf_output"
TOOL_FOLDER = "$baseDir/bin"

workflow Main{
    take:
    a
    b

    main:
    Module1(a, b)
}
workflow {
    _ = Main(params.input_spectra, params.publishDir)
    
}