# Source:
# https://github.com/ageitgey/face_recognition/blob/a9dd28d5f97e2b5d83791548eeb9c24a807bca73/Dockerfile
# https://github.com/ageitgey/face_recognition/blob/a9dd28d5f97e2b5d83791548eeb9c24a807bca73/Dockerfile.gpu

FROM python:3.6-slim-stretch
RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install -y --fix-missing \
    build-essential \
    make \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    python3-pip \
    python3-virtualenv \
    software-properties-common \
    zip \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install --yes USE_AVX_INSTRUCTIONS

RUN mkdir -p /app
WORKDIR /app
COPY requirements.txt requirements.txt ./
RUN pip3 install virtualenv
RUN python3 -m virtualenv venv
RUN . venv/bin/activate
RUN pip3 install -r requirements.txt

COPY . ./

RUN make unittest

CMD ["make", "prod"]
