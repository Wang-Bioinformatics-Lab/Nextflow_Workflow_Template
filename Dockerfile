# Build from an image with mamba
FROM condaforge/mambaforge

# Disable interactive installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest r-cran-devtools python3.6 python3-pip python3-setuptools python3-dev libpcre2-dev libbz2-dev zlib1g-dev liblzma-dev

# Install R packages
RUN Rscript -e "devtools::install_github('mjhelf/MassTools')"

# Copy the conda environment file to the docker image before nextflow mounts the directory so we can create the environment
# Note that the conda env is in the yml file 
COPY /bin/conda_env.yml /conda_env.yml

# Create the conda environment, clean to reduce image size
RUN mamba env create --file '/conda_env.yml' && mamba clean -a

# Add the environment to path so it's accessible with nextflow's conda directive
ENV PATH /opt/conda/envs/my_env/bin:$PATH