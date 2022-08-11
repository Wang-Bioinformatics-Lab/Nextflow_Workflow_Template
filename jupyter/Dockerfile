from jupyter/minimal-notebook:lab-3.4.4

COPY requirements.txt /
RUN pip install -r /requirements.txt

# Nextfow
RUN conda install -y mamba -c conda-forge
RUN mamba install -y -c bioconda nextflow

# Installing system dependencies
USER root
RUN apt-get update && apt-get install build-essential -y
USER jovyan