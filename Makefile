run:
	docker-compose -f docker-compose.yml build
	nextflow run ./nf_workflow.nf -resume