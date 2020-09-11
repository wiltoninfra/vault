
#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM python

# ensure local python is preferred over distribution python
#ENV PATH /usr/local/bin:$PATH
#ENV FLASK_APP=app.py
#ENV FLASK_ENV=development
#ENV FLASK_RUN_PORT=8000
#ENV FLASK_RUN_HOST=0.0.0.0
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
RUN apt update -y && apt install git unzip 

ENV LANG C.UTF-8
WORKDIR /app

COPY . /app
RUN pip install -r requirements.txt

#RUN django-admin startproject devinfra .
#RUN ls -lsa && ls -lsa /app && ls -lsa /app/devinfra && cat /app/devinfra/manage.py

EXPOSE 8000

ENTRYPOINT ["sh", "/app/entrypoint.sh"]