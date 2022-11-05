FROM continuumio/anaconda3:2022.05

MAINTAINER Jinsoo Kim <jjambbongjoa@gmail.com>

USER root

# -----------------------------------------------------------------------------
### SERVER COMMON Configuration
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime \
 && sed -i -- 's/^# alias/alias/g' /root/.bashrc \
 && sed -i -- 's/^# export/export/g' /root/.bashrc

# 한국 미러 서버로 변경
RUN sed -i 's/deb.debian.org/mirror.kakao.com/g' /etc/apt/sources.list
RUN apt-get update --allow-releaseinfo-change

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y procps

ENV JAVA_VERSION jdk-11.0.8+10

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='fb27ea52ed901c14c9fe8ad2fc10b338b8cf47d6762571be1fe3fb7c426bab7c'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.8_10.tar.gz'; \
         ;; \
       armhf|armv7l) \
         ESUM='d00370967e4657e137cc511e81d6accbfdb08dba91e6268abef8219e735fbfc5'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jdk_arm_linux_hotspot_11.0.8_10.tar.gz'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='d206a63cd719b65717f7f20ee3fe49f0b8b2db922986b4811c828db57212699e'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jdk_ppc64le_linux_hotspot_11.0.8_10.tar.gz'; \
         ;; \
       s390x) \
         ESUM='5619e1437c7cd400169eb7f1c831c2635fdb2776a401147a2fc1841b01f83ed6'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jdk_s390x_linux_hotspot_11.0.8_10.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='6e4cead158037cb7747ca47416474d4f408c9126be5b96f9befd532e0a762b47'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.8%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.8_10.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"
# -----------------------------------------------------------------------------
### Anaconda Configuration
# -----------------------------------------------------------------------------
RUN apt update -y && \
    apt install -y --no-install-recommends \
    git && \
    rm -rf /var/lib/apt/list/* /var/cache/apt/archives/*

WORKDIR /var/workspace/python
RUN conda update conda -y
RUN conda create -n science pip python=3.10 -y
RUN activate science
RUN echo "source activate science" >> ~/.bashrc
RUN echo "conda activate science" >> ~/.bashrc
ENV PATH /opt/conda/envs/science/bin:$PATH
RUN conda install -n science ipykernel
RUN python -m ipykernel install --user --name "science" --display-name "science"
RUN /opt/conda/bin/conda install jupyter -y --quiet

RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata g++ git curl

RUN apt-get install --reinstall -y make && apt-get install -y libtool

RUN conda update -n base conda -y
RUN conda update --all -y

RUN python -m pip install --upgrade pip
RUN pip install --upgrade --ignore-installed pip

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Mecab version
ENV MECAB_VERSION mecab-0.996-ko-0.9.2
ENV MECAB_DICT_VERSION mecab-ko-dic-2.1.1-20180720
ENV MECAB_PYTHON_VERSION mecab-python-0.996

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends


# Install Mecab
RUN set -ex \
    && curl -LO https://bitbucket.org/eunjeon/mecab-ko/downloads/${MECAB_VERSION}.tar.gz \
    && tar zxvf ${MECAB_VERSION}.tar.gz \
    && cd ${MECAB_VERSION} \
    && ./configure \
    && make \
    && make check \
    && make install \
    && ldconfig

# Install Mecab Dictionay
RUN set -ex \
    && curl -LO https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/${MECAB_DICT_VERSION}.tar.gz \
    && tar zxvf ${MECAB_DICT_VERSION}.tar.gz \
    && cd ${MECAB_DICT_VERSION} \
    && autoreconf \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && ldconfig

# Install mecab-python
RUN set -ex \
    && git clone https://bitbucket.org/eunjeon/${MECAB_PYTHON_VERSION}.git \
    && cd ${MECAB_PYTHON_VERSION} \
    && python setup.py build \
    && python setup.py install

RUN git clone https://github.com/entelecheia/eKoNLPy.git /tmp/eKoNLPy
RUN pip install /tmp/eKoNLPy

RUN pip install setuptools==56.0.0

RUN git clone https://github.com/scarletcho/KoLM.git /tmp/KoLM
RUN pip install /tmp/KoLM

RUN pip install pyyaml

#RUN git clone https://github.com/scarletcho/KoLM.git /tmp/KoLM
#RUN pip install /tmp/KoLM

WORKDIR    /opt/oracle
RUN        apt-get update && apt-get install -y libaio1 wget unzip \
            && wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip \
            && unzip instantclient-basiclite-linuxx64.zip \
            && rm -f instantclient-basiclite-linuxx64.zip \
            && cd /opt/oracle/instantclient* \
            && rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci \
            && echo /opt/oracle/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf \
            && ldconfig
WORKDIR /var/workspace/python

RUN conda install -c conda-forge jupyter_contrib_nbextensions

RUN pip install jupyter

ADD requirements.txt /tmp/

RUN pip install -r /tmp/requirements.txt

COPY nbconfig /root/.jupyter/nbconfig
ADD jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
