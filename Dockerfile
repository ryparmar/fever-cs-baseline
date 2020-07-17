FROM continuumio/miniconda3

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN apt-get update
RUN apt-get install -y --no-install-recommends --allow-unauthenticated \
    zip \
    gzip \
    make \
    automake \
    gcc \
    build-essential \
    g++ \
    cpp \
    libc6-dev \
    man-db \
    autoconf \
    pkg-config \
    unzip \
    libffi-dev \
    software-properties-common

RUN mkdir /fever
WORKDIR /fever

ADD requirements.txt /fever/
RUN pip install -r requirements.txt

RUN python -c "import nltk; nltk.download('punkt')"

RUN mkdir -pv src
RUN mkdir -pv configs

ADD src src
ADD configs configs

ADD predict.sh .

ENV PYTHONPATH .
ENV FLASK_APP fever_cs:make_api

#ENTRYPOINT ["/bin/bash","-c"]
RUN git clone https://github.com/heruberuto/fever-cs-baseline
ADD fever-cs-baseline fever-cs-baseline
RUN fever-cs-baseline/download_prebuilt.sh /local/fever-common/data
CMD ["waitress-serve", "--host=0.0.0.0", "--port=5000", "--call", "fever_cs:make_api"]