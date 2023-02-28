# syntax=docker/dockerfile:1

FROM ufoym/deepo:pytorch-py38-cpu

WORKDIR /python-docker

# Allow the non-root user to access the ./local and /.cache directory during pip install
RUN mkdir /.local
RUN mkdir /.cache
RUN chown -R 10016:10016 /.local
RUN chown -R 10016:10016 /.cache


COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Add gunicorn and flask bin files to path
RUN export PATH="/.local/bin:$PATH"

# Set the default user for the image to the non-root user
USER 10016

# This directory will be used by Hugging Face to download the model.
# /tmp is the only writable directory in Choreo.
ENV TRANSFORMERS_CACHE="/tmp"

COPY . .

CMD [ "gunicorn", "app:app" , "--bind=0.0.0.0:3000", "--access-logfile", "-", "--error-logfile", "-"]
