FROM runpod/worker-comfyui:5.8.4-base

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U comfy-cli

RUN comfy --workspace /comfyui update comfy --version latest

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml

RUN echo "=== BUILD: extra_model_paths ===" \
    && cat /comfyui/extra_model_paths.yaml

RUN cat > /debug-start.sh <<'EOF'
#!/bin/bash

echo "================================"
echo "SERVERLESS RUNTIME DEBUG"
echo "================================"

echo "=== /runpod-volume ==="
ls -lah /runpod-volume 2>&1 || true

echo "=== MODELS ==="
find /runpod-volume/models -maxdepth 2 -type f -printf "%p | %s bytes\n" 2>&1 || true

echo "=== EXTRA MODEL PATHS ==="
cat /comfyui/extra_model_paths.yaml 2>&1 || true

echo "=== COMFYUI ==="
ls -lah /comfyui 2>&1 | head -40 || true

echo "================================"
echo "STARTING ORIGINAL RUNPOD WORKER"
echo "================================"

exec /start.sh
EOF

RUN chmod +x /debug-start.sh

CMD ["/debug-start.sh"]
