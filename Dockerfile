FROM runpod/worker-comfyui:5.8.4-base

# MiniMax H3 native support landed in ComfyUI v0.30.0 (Aug 3, 2026), after this
# base image was built. Move ComfyUI core to the current stable release.
RUN comfy update comfy --version latest
