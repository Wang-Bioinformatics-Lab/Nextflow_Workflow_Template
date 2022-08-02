from jupyter/minimal-notebook:lab-3.4.4

COPY requirements.txt /
RUN pip install -r /requirements.txt

# Nextfow
# USER root
# RUN apt update && apt-get install -y curl zip
# USER jovyan
# RUN curl -s https://get.sdkman.io | bash
# RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java
# RUN wget -qO- https://get.nextflow.io | bash

RUN conda install -y mamba -c conda-forge
RUN mamba install -y -c bioconda nextflow

