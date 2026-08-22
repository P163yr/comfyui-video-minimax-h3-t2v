FROM runpod/worker-comfyui:5.8.4-base

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# ComfyUI core lives at /comfyui in this image — update it in place.
WORKDIR /comfyui
RUN git fetch --tags origin \
    && git checkout $(git tag --sort=-v:refname | head -n1) \
    && pip install --no-cache-dir -r requirements.txt
