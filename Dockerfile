FROM runpod/worker-comfyui:5.8.4-base

# comfy-cli needs git to move ComfyUI's checkout, and this base image doesn't have it.
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

# The bundled comfy-cli predates the `--version` flag on `comfy update`; upgrade it first.
RUN pip install -U comfy-cli

# MiniMax H3 native support landed in ComfyUI v0.30.0 (Aug 3, 2026), after this
# base image was built. Move ComfyUI core to the current stable release.
# ComfyUI already lives at /comfyui in this image, so point comfy-cli at it directly
# instead of letting it guess/create a workspace elsewhere.
RUN comfy --workspace /comfyui update comfy --version latest

# The base image's extra_model_paths.yaml only declares `unet` and `clip` as
# folder categories, not `diffusion_models` / `text_encoders`. MiniMax H3 model
# files on the network volume live under models/diffusion_models/ and
# models/text_encoders/, so ComfyUI never finds them without this fix.
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
