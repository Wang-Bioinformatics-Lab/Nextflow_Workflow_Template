FROM condaforge/miniforge3:23.11.0-0

# Random System Utilities
RUN apt-get update -y \
    && apt-get install -y libxrender-dev procps build-essential unzip vim

# Installing Nextflow
RUN mamba install -c bioconda nextflow=24.04.*

WORKDIR /test