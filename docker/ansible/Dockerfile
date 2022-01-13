FROM python:3.9

COPY requirements.txt /requirements.txt
COPY ansible/requirements.yaml /requirements.yaml

RUN apt-get update && apt-get install -y \
    openssh-client \
    libpq-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip wheel \
    && pip install --requirement requirements.txt \
    && ansible-galaxy collection install --requirements-file requirements.yaml \
    && rm requirements.txt requirements.yaml \
    && groupadd ansible \
    && useradd \
        --gid ansible \
        --create-home \
        --shell /bin/bash \
        ansible

USER ansible

WORKDIR /home/ansible

COPY ansible .