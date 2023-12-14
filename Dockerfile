# Base image with NVIDIA CUDA and cuDNN pre-installed, suitable for deep learning with compatible GPUs
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# Set the directory inside the container where commands will run
WORKDIR /StarGAN-VC

# Install system dependencies required for the project
RUN apt-get update && apt-get install -y \
    libsndfile1 \
    python3 \
    python3-pip \
    git \
    sudo \      
    vim \       
 && rm -rf /var/lib/apt/lists/*

# Create a symbolic link to set Python 3 as the default 'python' command
RUN ln -s /usr/bin/python3 /usr/bin/python

# Upgrade pip to ensure we have the latest version for installing Python packages
RUN python3 -m pip install --upgrade pip

# Copy the Python package requirements file into the container
COPY ./requirements.txt /StarGAN-VC/requirements.txt

# Install the Python packages specified in requirements.txt


# Install PyTorch, torchvision, and torchaudio with the version compatible with CUDA 12.2
RUN pip3 install --upgrade --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121 --force

RUN pip3 install --upgrade tf-nightly --force

RUN pip3 install --upgrade TensorRT  

RUN pip3 install --no-cache-dir --upgrade -r requirements.txt

# Copy the rest of the project files into the container
COPY . /StarGAN-VC

# Specify the command to run by default when the container starts
CMD ["python3", "train.py"]
