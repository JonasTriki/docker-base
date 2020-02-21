# Use an official Python runtime as a parent image
FROM nvidia/cuda

# Set the working directory to 
WORKDIR /project

# Copy what you need into the working directory
COPY requirements-pip.txt /
COPY requirements-apt.txt /

# User configuration - override with --build-arg
ARG user=myuser
ARG group=mygroup
ARG uid=1000
ARG gid=1000

# Some debs want to interact, even with apt-get install -y, this fixes it
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/project

# Install any needed packages specified in requirements-*.txt
RUN apt-get update && apt-get install sudo && grep -v ^# /requirements-apt.txt | xargs apt-get install -y 
RUN pip3 install --trusted-host pypi.python.org -r /requirements-pip.txt

RUN groupadd -g $gid $user
RUN useradd -u $uid -g $gid $user
RUN usermod -a -G sudo $user
RUN passwd -d $user

# Make port 80 available to the world outside this container
# EXPOSE 80

# Define environment variable
# Use only GPU 0
ENV CUDA_VISIBLE_DEVICES 0

# Run when the container launches
CMD "bash"
