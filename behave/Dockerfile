FROM python:2-onbuild

COPY requirements.txt /usr/src/app/

ADD steps steps
ADD tutorial.feature tutorial.feature

ENTRYPOINT behave
