#!/usr/bin/env bash

## install.sh: run during a Travis CI or AppVeyor build to install the conda environment.

# Set options for extra caution & debugging
set -o errexit \
    -o pipefail

wget https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh \
    --output-document miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda
source $HOME/miniconda/etc/profile.d/conda.sh
hash -r
conda config \
  --set always_yes yes \
  --set changeps1 no
conda env create --quiet --file build/environment.yml
conda list --name manubot
conda activate manubot

# Install Spellcheck filter for Pandoc
# Only tested in AppVeyor
if [ "${SPELLCHECK:-}" = "true" ]; then
  sudo apt-get update -y
  sudo apt-get install -y aspell aspell-en
  wget https://raw.githubusercontent.com/agitter/lua-filters/e6dcba293363ca82fb9545e0b1ddc934098a47b4/spellcheck/spellcheck.lua
fi
