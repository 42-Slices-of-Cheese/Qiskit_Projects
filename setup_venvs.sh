#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Install Git LFS if not already installed
if command -v git-lfs >/dev/null 2>&1; then
  echo "Git LFS is already installed. Skipping installation."
else
  echo "Git LFS is not installed. Proceeding with installation."

  # 1. Update package lists and install git-lfs
  echo "Updating apt repository and installing git-lfs."
  sudo apt update
  sudo apt install -y git-lfs

  # 2. Initialize Git LFS hooks globally
  echo "Initializing Git LFS system hooks."
  git lfs install

  echo "Git LFS setup completed successfully!"
fi

# Use a hidden directory so venvs don't clutter the repo or get committed
mkdir -p .venvs

# Determine a usable python for general venvs
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "No python interpreter found (python3 or python). Aborting."
  exit 1
fi

echo "Using $PY to create general venvs (qiskit, qiskit-nature)"
$PY -m venv .venvs/qiskit
$PY -m venv .venvs/qiskit-nature

echo "Installing qiskit in .venvs/qiskit"
.venvs/qiskit/bin/python -m pip install --upgrade pip
.venvs/qiskit/bin/python -m pip install qiskit

echo "Installing qiskit-nature in .venvs/qiskit-nature"
.venvs/qiskit-nature/bin/python -m pip install --upgrade pip
.venvs/qiskit-nature/bin/python -m pip install qiskit-nature

# quantum-metal requires Python 3.12
if command -v python3.12 >/dev/null 2>&1; then
  echo "Creating quantum-metal venv with python3.12"
  python3.12 -m venv .venvs/quantum-metal
  echo "Installing quantum-metal packages in .venvs/quantum-metal"
  .venvs/quantum-metal/bin/python -m pip install --upgrade pip
  .venvs/quantum-metal/bin/python -m pip install quantum-metal
else
  echo "Warning: python3.12 not found. Skipping quantum-metal venv."
  echo "To create it, install Python 3.12 (system package, pyenv, or deadsnakes) and rerun this script."
fi

echo "Created venvs in .venvs/"
echo "Activation:"
echo "  source .venvs/qiskit/bin/activate"
echo "  source .venvs/qiskit-nature/bin/activate"
echo "  source .venvs/quantum-metal/bin/activate  # requires Python 3.12 venv to exist"
