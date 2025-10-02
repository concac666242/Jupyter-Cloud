# Sử dụng image chính thức của Docker-in-Docker
FROM docker:dind

# Tắt prompt khi cài đặt
ARG DEBIAN_FRONTEND=noninteractive

# Cài đặt các công cụ cần thiết + Python + ufw + sudo
RUN apk add --no-cache \
    bash curl wget git htop nano unzip \
    iputils net-tools tmux screen neofetch \
    python3 py3-pip sudo ufw

# Cài đặt Jupyter Notebook
RUN pip3 install --no-cache-dir jupyter

# Copy source code (nếu có)
WORKDIR /app
COPY . /app

# Mở cổng 8888 cho Jupyter
EXPOSE 8888

# Khởi chạy Docker daemon + Jupyter Notebook không cần token
CMD sh -c "neofetch && dockerd & sleep 5 && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''"
