# Nextflow Template

To run the workflow to test simply do

```
make run
```

To learn NextFlow checkout this documentation:

https://www.nextflow.io/docs/latest/index.html

## Installation

You will need to have conda, mamba, and nextflow installed to run things locally. 

## Deployment to GNPS2

In order to deploy, we have a set of deployment tools that will enable deployment to the various gnps2 systems. To run the deployment, use the following commands from the deploy_gnps2 folder. 

You might need to checkout the module, do this by running

```
git submodule init
git submodule update
```

You will also need to specify the user on the server that you've been given that your public key has been associated with. If you want to not enter this every time you do a deployment, you can create a Makefile.credentials file in the deploy_gnps2 folder with the following contents

```
USERNAME=<enter the username>
```

### Deployment Dependencies

You will need to install the dependencies in GNPS2_DeploymentTooling/requirements.txt

### Deploying to Dev Server

To deploy to development, use the following command, if you don't have your ssh public key installed onto the server, you will not be able to deploy.

```
make deploy-dev
```

### Deploying to Production Server

To deploy to production, use the following command, if you don't have your ssh public key installed onto the server, you will not be able to deploy.

```
make deploy-prod
```