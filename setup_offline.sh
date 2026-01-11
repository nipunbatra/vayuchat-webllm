#!/bin/bash
# Setup script to download all dependencies for fully offline usage

set -e

echo "=== VayuChat Offline Setup ==="
echo ""

# Create directories
mkdir -p pyodide
mkdir -p models

# Download Pyodide
PYODIDE_VERSION="0.26.4"
echo "[1/3] Downloading Pyodide v${PYODIDE_VERSION}..."

cd pyodide
curl -L -O "https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/pyodide.js"
curl -L -O "https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/pyodide.asm.js"
curl -L -O "https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/pyodide.asm.wasm"
curl -L -O "https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/pyodide_py.tar"
curl -L -O "https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/packages.json"

echo "[2/3] Downloading Python packages..."
# Get package list and download required packages
PACKAGES=(
    "pandas-2.2.3-cp312-cp312-pyodide_2024_0_wasm32.whl"
    "numpy-2.0.2-cp312-cp312-pyodide_2024_0_wasm32.whl"
    "matplotlib-3.9.2-cp312-cp312-pyodide_2024_0_wasm32.whl"
    "python_dateutil-2.9.0.post0-py2.py3-none-any.whl"
    "pytz-2024.2-py2.py3-none-any.whl"
    "six-1.16.0-py2.py3-none-any.whl"
    "pyparsing-3.1.4-py3-none-any.whl"
    "packaging-24.1-py3-none-any.whl"
    "cycler-0.12.1-py3-none-any.whl"
    "kiwisolver-1.4.7-cp312-cp312-pyodide_2024_0_wasm32.whl"
    "contourpy-1.3.0-cp312-cp312-pyodide_2024_0_wasm32.whl"
    "fonttools-4.54.1-py3-none-any.whl"
    "pillow-10.4.0-cp312-cp312-pyodide_2024_0_wasm32.whl"
)

for pkg in "${PACKAGES[@]}"; do
    echo "  Downloading $pkg..."
    curl -L -O "https://cdn.jsdelivr.net/pyodide/v${PYODIDE_VERSION}/full/${pkg}" 2>/dev/null || echo "  (optional package, skipping)"
done

cd ..

echo "[3/3] Downloading LLM model..."
echo "  This will download ~900MB for Qwen2.5-Coder-1.5B"
echo ""

# Download model using WebLLM's model files
cd models
MODEL_BASE="https://huggingface.co/mlc-ai/Qwen2.5-Coder-1.5B-Instruct-q4f16_1-MLC/resolve/main"

# Model config files
curl -L -O "${MODEL_BASE}/mlc-chat-config.json"
curl -L -O "${MODEL_BASE}/tokenizer.json"
curl -L -O "${MODEL_BASE}/tokenizer_config.json"

# Model weights (multiple shards)
echo "  Downloading model weights (this takes a while)..."
for i in {0..24}; do
    printf "  Shard %02d/24\r" $i
    curl -L -O "${MODEL_BASE}/params_shard_${i}.bin" 2>/dev/null || true
done
echo ""

cd ..

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Total size:"
du -sh pyodide models
echo ""
echo "To use offline, update index.html to load from ./pyodide/ instead of CDN"
echo "See index_offline.html for the modified version"
