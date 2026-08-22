# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# Models now live on a RunPod Network Volume instead of being baked into the image.
# See the volume folder layout below — no download steps needed here anymore.
