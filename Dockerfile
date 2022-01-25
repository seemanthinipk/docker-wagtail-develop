# Use an official Python runtime as a parent image
FROM python:3.8-bullseye
LABEL maintainer="hello@wagtail.io"

# Set environment varibles
ENV PYTHONUNBUFFERED 1

# Install libenchant and create the requirements folder.
RUN apt-get update -y \
    && apt-get install -y libenchant-2-dev postgresql-client git sudo vim tmux openssh-server \
    && mkdir -p /code/requirements

# Install the bakerydemo project's dependencies into the image.
COPY ./entrypoint.sh  /code/
COPY ./bakerydemo/requirements/* /code/requirements/
RUN pip install --upgrade pip \
    && pip install -r /code/requirements/production.txt

# INSTALL Python packages
RUN pip install seaborn matplotlib pandas jupyter

# Install wagtail from the host. This folder will be overwritten by a volume mount during run time (so that code
# changes show up immediately), but it also needs to be copied into the image now so that wagtail can be pip install'd.
COPY ./wagtail /code/wagtail/
RUN cd /code/wagtail/ \
    && pip install -e .[testing,docs]

RUN useradd docker -d /home/docker -m -s /bin/bash
RUN ssh-keygen -A
RUN echo 'Port 22' >> /etc/ssh/sshd_config
RUN echo 'LoginGraceTime 120' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN echo ':set expandtab' > /home/docker/.vimrc
RUN echo ':set tabstop=2' >> /home/docker/.vimrc
RUN echo ':set shiftwidth=2' >> /home/docker/.vimrc
RUN echo ':set hls' >> /home/docker/.vimrc
RUN mkdir -p /home/docker/public_html
RUN chmod 0770 /home/docker/public_html
RUN chown docker:www-data /home/docker/public_html
RUN echo "root:root" | chpasswd 
RUN echo "docker:docker" | chpasswd 
EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 8100
EXPOSE 8200
EXPOSE 8300
EXPOSE 8180
EXPOSE 8280
EXPOSE 8380
EXPOSE 8888
