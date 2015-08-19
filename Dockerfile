FROM ubuntu
MAINTAINER Cédric Donner <cedonner@gmail.com>

RUN (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git python3 python3-dev python3-setuptools nginx sqlite3 supervisor)
RUN (easy_install3 pip &&\
  pip3 install uwsgi)

# RUN mkdir /opt/django
# WORKDIR /opt/django
# RUN git clone https://github.com/csud-elearn/quizTM-2014.git && ln -s quizTM-2014/webmath app

ADD app/requirements.txt /opt/django/app/requirements.txt

RUN pip3 install -r /opt/django/app/requirements.txt
ADD . /opt/django/

RUN (echo "daemon off;" >> /etc/nginx/nginx.conf &&\
  rm /etc/nginx/sites-enabled/default &&\
  ln -s /opt/django/django.conf /etc/nginx/sites-enabled/ &&\
  ln -s /opt/django/supervisord.conf /etc/supervisor/conf.d/)

VOLUME ["/opt/django/app"]
EXPOSE 80
CMD ["/opt/django/run.sh"]
