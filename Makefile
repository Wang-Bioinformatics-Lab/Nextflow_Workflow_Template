run:
	nextflow run ./nf_workflow.nf --resume -c nextflow.config

run_docker:
	nextflow run ./nf_workflow.nf --resume -with-docker <CONTAINER NAME>