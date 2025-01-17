# Start with BioSim base image.
ARG BASE_IMAGE=hub-5.2.1-2025-01-15
FROM harbor.stfc.ac.uk/biosimulation-cloud/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Install nb env deps
RUN pip install jupyterhub-tmpauthenticator

# Install workshop deps
RUN conda install mdtraj matplotlib numpy scipy -y
RUN conda install ipywidgets -c conda-forge -y
RUN pip install mdplus
RUN pip install rlcluster

# Copy updated lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/CCPBioSim/clustering-workshop.git && \
    mv clustering-workshop/* . && \
    rm -r requirements.txt AUTHORS LICENSE README.md clustering-workshop

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
