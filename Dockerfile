# syntax=docker/dockerfile:1

FROM ufoym/deepo:pytorch-py38-cpu

WORKDIR /python-docker

RUN mkdir /.local
RUN mkdir /.cache
RUN mkdir /.cache/huggingface
RUN chown -R 10016:10016 /.local
RUN chown -R 10016:10016 /.cache
RUN chown -R 10016:10016 /.cache/huggingface
RUN mkdir transformer_cache
RUN chown -R 10016:10016 /python-docker/transformer_cache


COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN pwd
RUN ls
RUN export PATH="/.local/bin:$PATH"

# Set the default user for the image to the non-root user
USER 10016


ENV TRANSFORMERS_CACHE="/tmp"

COPY . .

CMD [ "gunicorn", "app:app" , "--bind=0.0.0.0:3000", "--access-logfile", "-", "--error-logfile", "-"]
#flask run --host=0.0.0.0 --port=5005
#CMD [ "flask", "run", "--host=0.0.0.0", "--port=5005"]
#gunicorn app:app --bind=0.0.0.0:3000 --access-logfile - --error-logfile -
