# VayuChat - Natural Language Data Analysis

Chat with your data using natural language. Runs entirely in the browser - no server required.

**Live Demo:** https://nipunbatra.github.io/vayuchat-webllm/

## Features

- **Natural Language Queries** - Ask questions about your data in plain English
- **Python Code Generation** - LLM generates pandas/matplotlib code automatically
- **Interactive Visualizations** - Charts, heatmaps, boxplots rendered inline
- **100% Client-Side** - All processing happens in your browser

## Why Browser-Based?

| Feature | VayuChat | Traditional Setup |
|---------|----------|-------------------|
| Installation | None - just open URL | Python, pip, dependencies |
| Server | Not needed | Required for most LLM apps |
| Data Privacy | Data never leaves your device | Often sent to cloud APIs |
| Cross-Platform | Any device with a browser | OS-specific setup |
| GPU Required | No (runs on WebGPU/WASM) | Often yes |
| Offline Capable | Yes, after first model load | Depends |

## Technology Stack

- **[WebLLM](https://github.com/mlc-ai/web-llm)** - Run LLMs directly in browser via WebGPU
- **[Pyodide](https://pyodide.org/)** - Python runtime compiled to WebAssembly
- **pandas** - Data manipulation and analysis
- **matplotlib** - Visualization library

## Run Locally

```bash
# Clone the repository
git clone https://github.com/nipunbatra/vayuchat-webllm.git
cd vayuchat-webllm

# Start a local server (Python 3)
python -m http.server 8888

# Open in browser
open http://localhost:8888
```

Or use any static file server:
```bash
# Node.js
npx serve .

# PHP
php -S localhost:8888
```

## Browser Requirements

- **Chrome/Edge 113+** (recommended) - Full WebGPU support
- **Safari 18+** - WebGPU support
- **Firefox** - Limited support (WebGPU behind flag)

## Available Models

| Model | Size | Best For |
|-------|------|----------|
| Qwen2.5-Coder-1.5B | ~900MB | Code generation (recommended) |
| Qwen2.5-Coder-7B | ~4GB | Better code quality, slower |
| Llama-3.2-3B | ~2GB | General purpose |
| Phi-3.5-mini | ~2GB | Balanced performance |

Models are downloaded once and cached in browser storage.

## Sample Queries

- "Show average PM2.5 by city"
- "Plot daily pollution trend for Delhi"
- "Which city has the best air quality?"
- "Show correlation matrix of all pollutants"
- "Create a heatmap of PM2.5 by hour and day of week"

## Custom Data

1. Click "Drop CSV files here" or drag-and-drop your CSV
2. Data is loaded as a pandas DataFrame
3. Ask questions about your data

## Fully Offline Setup

To run without any internet connection (even on first load):

```bash
# Download all dependencies (~1.2GB total)
./setup_offline.sh

# Use the offline version
open http://localhost:8888/index_offline.html
```

This downloads:
- Pyodide + Python packages (~150MB)
- Qwen2.5-Coder-1.5B model (~900MB)

After setup, works completely offline on Mac, iPad, or any device with a modern browser.

## License

MIT

## Credits

Built with Claude Code. Uses air quality sample data inspired by Indian city pollution monitoring.
