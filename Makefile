run:
	nextflow run ./nf_workflow.nf --resume 

run_docker:
	nextflow run ./nf_workflow.nf --resume -with-docker <CONTAINER NAME>