FROM jupyter/datascience-notebook

USER root

# install apt requirements
COPY apt-requirements.txt "${WORKDIR}"
RUN apt-get -y update && \
    xargs apt-get install -y < apt-requirements.txt && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# install conda packages
COPY conda-requirements.txt $HOME/conda-requirements.txt
RUN conda install -c conda-forge --yes --quiet --file conda-requirements.txt && \
    conda clean -tipsy

# Set up jupyter extensions
RUN jupyter nbextension enable --py widgetsnbextension && \
    jupyter serverextension enable --py jupyterlab

ENTRYPOINT ["tini", "--", "start.sh", "jupyter lab"]