FROM ubuntu:vivid

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
    git \
    zsh \
    bzip2 \
	&& rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' gleber 

# Nix requires ownership of /nix.
RUN mkdir -m 0755 /nix && chown gleber /nix

# Change docker user to gleber
USER gleber

# Set some environment variables for Docker and Nix
ENV USER gleber

# Change our working directory to $HOME
WORKDIR /home/gleber
