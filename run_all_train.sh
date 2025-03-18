#!/bin/bash

python train_ssd.py --dataset "OPIXray" --model_arch "original" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/OPIXray/original/
python train_ssd.py --dataset "OPIXray" --model_arch "DOAM" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/OPIXray/DOAM/
python train_ssd.py --dataset "OPIXray" --model_arch "LIM" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/OPIXray/LIM/
python train_ssd.py --dataset "HiXray" --model_arch "original" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/HiXray/original/
python train_ssd.py --dataset "HiXray" --model_arch "DOAM" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/HiXray/DOAM/
python train_ssd.py --dataset "HiXray" --model_arch "LIM" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/HiXray/LIM/
python train_ssd.py --dataset "XAD" --model_arch "original" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/XAD/original/
python train_ssd.py --dataset "XAD" --model_arch "DOAM" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/XAD/DOAM/
python train_ssd.py --dataset "XAD" --model_arch "LIM" --transfer ./weights/ssd300_mAP_77.43_v2.pth --save_folder ./save/XAD/LIM/
