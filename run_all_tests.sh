#!/bin/bash
python test_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth  --phase results/OPIXray///vanilla/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/OPIXray///vanilla/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/OPIXray///vanilla/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/HiXray///vanilla/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/HiXray///vanilla/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/HiXray///vanilla/adver_image
python test_ssd.py --dataset "XAD" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/XAD///vanilla/adver_image
python test_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/XAD///vanilla/adver_image


python test_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth  --phase test
python test_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth  --phase results/OPIXray/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth  --phase results/OPIXray/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth  --phase results/OPIXray/iron/reinforce/original/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/OPIXray/iron_fix/fix/DOAM/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/OPIXray/iron/fix_patch/DOAM/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/OPIXray/iron/reinforce/DOAM/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/OPIXray/iron_fix/fix/LIM/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/OPIXray/iron/fix_patch/LIM/adver_image
python test_ssd.py --dataset "OPIXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/OPIXray/iron/reinforce/LIM/adver_image


python test_ssd.py --dataset "HiXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "HiXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/HiXray/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/HiXray/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/HiXray/iron/reinforce/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/HiXray/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/HiXray/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/HiXray/iron/reinforce/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/HiXray/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/HiXray/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "HiXray" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/HiXray/iron/reinforce/original/adver_image

python test_ssd.py --dataset "XAD" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "XAD" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/XAD/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/XAD/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "original" --ckpt_path save/OPIXray/original/ssd300_Xray_knife_50.pth --phase results/XAD/iron/reinforce/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/XAD/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/XAD/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "DOAM" --ckpt_path save/OPIXray/DOAM/ssd300_Xray_knife_50.pth --phase results/XAD/iron/reinforce/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase test
python test_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/XAD/iron_fix/fix/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/XAD/iron/fix_patch/original/adver_image
python test_ssd.py --dataset "XAD" --model_arch "LIM" --ckpt_path save/OPIXray/LIM/ssd300_Xray_knife_50.pth --phase results/XAD/iron/reinforce/original/adver_image
