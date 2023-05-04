#!/bin/bash

# Activates the environment
#eval "$(conda shell.bash hook)"
#source activate tf-gpu-cv

# Alternatively, activate the environment first and run below commands

# Install NVCC
#conda install -c nvidia cuda-nvcc=11.3.58


# Configure the XLA cuda directory
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
printf 'export XLA_FLAGS=--xla_gpu_cuda_data_dir=$CONDA_PREFIX/lib/\n' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

# Copy libdevice file to the required path
mkdir -p $CONDA_PREFIX/lib/nvvm/libdevice
cp $CONDA_PREFIX/lib/libdevice.10.bc $CONDA_PREFIX/lib/nvvm/libdevice/
