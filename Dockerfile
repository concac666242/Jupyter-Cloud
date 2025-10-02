# Base Ubuntu image
FROM ubuntu:22.04

# Tắt prompt cài đặt
ARG DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt các tool cần thiết
RUN apt update && apt install -y \
    python3 python3-pip \
    curl wget git htop nano unzip \
    net-tools iputils-ping \
    tmux screen \
    ca-certificates gnupg lsb-release \
    && apt clean

# Cài Docker CLI (client)
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && apt install -y docker-ce-cli
