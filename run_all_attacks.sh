#!/bin/bash

python attack_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "Original" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "Original" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "Original" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "Original" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "Original" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "Original" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix" --patch_material "iron_fix" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results
python attack_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/ssd300_Xray_knife_50.pth --patch_place "reinforce" --patch_material "iron" --save_path ./results

#VANILLA
python attack_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results_vanila --num_iters 0
python attack_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results_vanila --num_iters 0
python attack_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results_vanila --num_iters 0

#reinforced patch
python attack_ssd_patch.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results_patch --num_iters 0
python attack_ssd_patch.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results_patch --num_iters 0
python attack_ssd_patch.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --patch_place "fix_patch" --patch_material "iron" --save_path ./results_patch --num_iters 0