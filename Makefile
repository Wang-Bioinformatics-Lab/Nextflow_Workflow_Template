run:
	nextflow run ./nf_workflow.nf -resume -c nextflow.config

run_importer_workflow:
	nextflow run ./nf_workflow_importer.nf -resume -c nextflow.config

run_slurm:
	nextflow run ./nf_workflow.nf -resume -c nextflow_slurm.config

run_docker:
	nextflow run ./nf_workflow.nf -resume -with-docker <CONTAINER NAME>