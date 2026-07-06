#!/bin/bash
source .venv/bin/activate
pip install --upgrade pip
pip install ipykernel qiskit qiskit-nature qiskit-ibm-runtime pyscf matplotlib pylatexenc matplotlib rdkit geometric git-lfs
git lfs install