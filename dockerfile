# Build da imagem
#   docker build -f dockerfile -t aluno_muriloluz-openr1-std:latest .

# Verificar se o driver da GPU está funcionando (docker do linux)
#  docker run -it --rm --gpus all --privileged aluno_muriloluz-openr1-std:latest sh -c 'ldconfig; nvidia-smi'

# Run da imagem
# docker run --gpus all -v /raid/muriloluz/openr1-std/huggingface-cache:/root/.cache/huggingface -v /raid/muriloluz/openr1-std/project:/project -it aluno_muriloluz-openr1-std:latest

# docker run -it --gpus "device=0" --privileged aluno_muriloluz-openr1-std:latest
# executar pip install flash-attn==2.5.0 (pelo que investiguei esta com um erro se isso estiver)
# e entao executar o script q esta dentro de custom

# docker run -it --rm --gpus "device=0" --privileged aluno_muriloluz-openr1-std:latest sh -c 'ldconfig; nvidia-smi'


# docker run -it --gpus '"device=0,1,5"'  aluno_muriloluz-openr1-std:latest 

# docker run -it -d --gpus '"device=0,1,5"' -v /raid/muriloluz/openr1-std/huggingface-cache:/root/.cache/huggingface -v /raid/muriloluz/openr1-std/app:/app --name aluno_muriloluz-openr1-std aluno_muriloluz-openr1-std:latest


FROM nvidia/cuda:12.4.0-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    git \
    git-lfs \
    ca-certificates \
    build-essential \
    nano

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
apt-get install -y python3.11 python3.11-venv python3.11-dev

RUN update-alternatives --install /usr/bin/python3 python3.11 /usr/bin/python3.11 1

RUN wget https://bootstrap.pypa.io/get-pip.py && \
python3.11 get-pip.py && \
rm get-pip.py

RUN python3.11 -m pip install --upgrade pip
RUN python3.11 -m pip install vllm==0.7.2 accelerate huggingface-hub wandb

# WORKDIR /app
# RUN git clone https://github.com/muriloluz/open-r1

RUN git pull

WORKDIR /app/open-r1

RUN python3.11 -m pip install -e .