# Base Ubuntu image
FROM ubuntu:22.04

# Tắt prompt cài đặt
ARG DEBIAN_FRONTEND=noninteractive

# Cập nhật và cài đặt các tool cần thiết (thêm sudo, ufw, docker)
RUN apt update && apt install -y \
    python3 python3-pip \
    curl wget git htop nano unzip \
    net-tools iputils-ping \
    tmux screen neofetch \
    sudo ufw ca-certificates gnupg lsb-release \
    && apt clean

# Cài Docker (thêm kho chính thức để có phiên bản mới)
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
       | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && apt clean

# Cài đặt Jupyter Notebook
RUN pip3 install --no-cache-dir jupyter

# Copy source code nếu có
COPY . /app
WORKDIR /app

# Mở cổng 8888 cho Jupyter
EXPOSE 8888

# Khởi chạy Docker + Jupyter Notebook không cần token/password
CMD ["bash", "-c", "neofetch && service docker start && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''"]
