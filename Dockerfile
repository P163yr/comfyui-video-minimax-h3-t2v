FROM runpod/worker-comfyui:5.8.4-base

# comfy-cli needs git to move ComfyUI's checkout, and this base image doesn't have it.
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# The bundled comfy-cli predates the `--version` flag on `comfy update`; upgrade it first.
RUN pip install -U comfy-cli

# MiniMax H3 native support landed in ComfyUI v0.30.0 (Aug 3, 2026), after this
# base image was built. Move ComfyUI core to the current stable release.
RUN comfy update comfy --version latest
