#!/bin/bash

# Experiment configurations
MODEL_ARCHS=("LIM" "SSD" "DOAM")
ALPHAS=("1.0" "2.0" "3.0")
GAMMAS=("0.5" "1.0" "1.5")
FOCUS_CLASS=("3")

# Base command
BASE_CMD="python attack_ssd_loss.py --dataset OPIXray --patch_place reinforce --patch_material iron"

# Run experiments
for model_arch in "${MODEL_ARCHS[@]}"; do
    # Set model-specific checkpoint path
    case $model_arch in
        "LIM")
            CKPT_PATH="save/OPIXray/LIM/ssd300_Xray_knife_50.pth"
            ;;
        "SSD")
            CKPT_PATH="save/OPIXray/SSD/ssd300_Xray_knife_50.pth"
            ;;
        "DOAM")
            CKPT_PATH="save/OPIXray/DOAM/ssd300_Xray_knife_50.pth"
            ;;
    esac

    for alpha in "${ALPHAS[@]}"; do
        for gamma in "${GAMMAS[@]}"; do
            echo "=============================================="
            echo "Running experiment:"
            echo "Model: $model_arch"
            echo "Alpha: $alpha"
            echo "Gamma: $gamma"
            echo "=============================================="
            
            # Run command with current parameters
            $BASE_CMD \
                --model_arch "$model_arch" \
                --ckpt_path "$CKPT_PATH" \
                --alpha "$alpha" \
                --gamma "$gamma" \
                --save_path "./results/${model_arch}/alpha_${alpha}_gamma_${gamma}" \
                --focus_class "${FOCUS_CLASS[@]}"
            
            echo -e "\n\n"
        done
    done
done