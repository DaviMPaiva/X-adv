import os

import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.autograd import Variable

from layers import Detect, PriorBox, L2Norm, Boundary_Aggregation


class SSD_LIM(nn.Module):
    """Single Shot Multibox Architecture
    The network is composed of a base VGG network followed by the
    added multibox conv layers.  Each multibox layer branches into
        a1) conv2d for class conf scores
        a2) conv2d for localization predictions
        3) associated priorbox layer to produce default bounding
           boxes specific to the layer's feature map size.
    See: https://arxiv.org/pdf/1512.02325.pdf for more details.

    Args:
        phase: (string) Can be "test" or "train"
        size: input image size
        base: VGG16 layers for input, size of either 300 or 500
        extras: extra layers that feed to multibox loc and conf layers
        head: "multibox head" consists of loc and conf conv layers
    """

    def __init__(self, phase, size, base, num_classes, head_fpn, cfg):
        super(SSD_LIM, self).__init__()
        self.phase = phase
        self.num_classes = num_classes
        self.cfg = cfg
        self.priorbox = PriorBox(self.cfg)
        self.priors = Variable(self.priorbox.forward(), volatile=True)
        self.size = size

        # SSD network
        self.vgg = nn.ModuleList(base)  # vgg16

        # Layer learns to scale the l2 normalized features from conv4_3
        self.L2Norm1 = L2Norm(512, 20)
        self.L2Norm3 = L2Norm(256, 40)
        self.L2Norm4 = L2Norm(128, 80)

        self.loc_fpn = nn.ModuleList(head_fpn[0])
        self.conf_fpn = nn.ModuleList(head_fpn[1])
        self.DenseFPN = DenseFeaturePyramidNetwork(256, 512, 1024)

        self.softmax = nn.Softmax(dim=-1)
        self.detect = Detect(num_classes, 0, 200, 0.01, 0.45, cfg["variance"])

    def forward(self, x):
        """Applies network layers and ops on input image(s) x.

        Args:
            x: input image or batch of images. Shape: [batch,3,300,300].

        Return:
            Depending on phase:
            test:
                Variable(tensor) of output class label predictions,
                confidence score, and corresponding location predictions for
                each object detected. Shape: [batch,topk,7]

            train:
                list of concat outputs from:
                    a1: confidence layers, Shape: [batch*num_priors,num_classes]
                    a2: localization layers, Shape: [batch,num_priors*4]
                    3: priorbox layers, Shape: [a2,num_priors*4]
        """
        sources_fpn = list()
        FPN_feature = list()
        loc_fpn = list()
        conf_fpn = list()

        # apply vgg up to conv4_3 relu
        for k in range(23):  # k=9~10,16~17,,22
            x = self.vgg[k](x)
            if k == 15:
                s = self.L2Norm3(x)
                FPN_feature.append(s)

        s = self.L2Norm1(x)
        FPN_feature.append(s)

        # apply vgg up to fc7
        for k in range(23, len(self.vgg)):
            x = self.vgg[k](x)

        FPN_feature.append(x)

        # apply extra layers and cache source layer outputs
        sources_fpn = self.DenseFPN(FPN_feature)

        for x, l, c in zip(sources_fpn, self.loc_fpn, self.conf_fpn):
            loc_fpn.append(l(x).permute(0, 2, 3, 1).contiguous())
            conf_fpn.append(c(x).permute(0, 2, 3, 1).contiguous())
        loc_fpn = torch.cat([o.view(o.size(0), -1) for o in loc_fpn], 1)
        conf_fpn = torch.cat([o.view(o.size(0), -1) for o in conf_fpn], 1)

        if self.phase == "test":
            output = self.detect(
                loc_fpn.view(loc_fpn.size(0), -1, 4),  # loc preds
                self.softmax(
                    conf_fpn.view(conf_fpn.size(0), -1, self.num_classes)
                ),  # conf preds
                self.priors.to(loc_fpn.device),  # default boxes
            )

        else:
            output = (
                loc_fpn.view(loc_fpn.size(0), -1, 4),
                conf_fpn.view(conf_fpn.size(0), -1, self.num_classes),
                self.priors.to(loc_fpn.device),
            )

        return output

    def load_weights(self, base_file, isStrict=True):
        other, ext = os.path.splitext(base_file)
        if ext == ".pkl" or ".pth":
            print("Loading weights into state dict...")

            self.load_state_dict(
                torch.load(base_file, map_location=lambda storage, loc: storage),
                strict=isStrict,
            )

            print("Finished!")
        else:
            print("Sorry only .pth and .pkl files supported.")


# This function is derived from torchvision VGG make_layers()
# https://github.com/pytorch/vision/blob/master/torchvision/models/vgg.py
def vgg(cfg, i, batch_norm=False):
    layers = []
    in_channels = i
    for v in cfg:
        if v == "M":
            layers += [nn.MaxPool2d(kernel_size=2, stride=2)]
        elif v == "C":
            layers += [nn.MaxPool2d(kernel_size=2, stride=2, ceil_mode=True)]
        else:
            conv2d = nn.Conv2d(in_channels, v, kernel_size=3, padding=1)
            if batch_norm:
                layers += [conv2d, nn.BatchNorm2d(v), nn.ReLU(inplace=True)]
            else:
                layers += [conv2d, nn.ReLU(inplace=True)]
            in_channels = v
    pool5 = nn.MaxPool2d(kernel_size=3, stride=1, padding=1)
    conv6 = nn.Conv2d(512, 1024, kernel_size=3, padding=6, dilation=6)
    conv7 = nn.Conv2d(1024, 1024, kernel_size=1)
    layers += [pool5, conv6, nn.ReLU(inplace=True), conv7, nn.ReLU(inplace=True)]
    return layers


def add_extras(cfg, i, batch_norm=False):
    # Extra layers added to VGG for feature scaling
    layers = []
    in_channels = i
    flag = False
    for k, v in enumerate(cfg):
        if in_channels != "S":
            if v == "S":
                layers += [
                    nn.Conv2d(
                        in_channels,
                        cfg[k + 1],
                        kernel_size=(1, 3)[flag],
                        stride=2,
                        padding=1,
                    )
                ]
            else:
                layers += [nn.Conv2d(in_channels, v, kernel_size=(1, 3)[flag])]
            flag = not flag
        in_channels = v
    return layers


def multibox_fpn(cfg, num_classes):
    loc_layers = []
    conf_layers = []
    fpn_source = [256, 256, 256, 256, 256]
    for k, v in enumerate(fpn_source):
        loc_layers += [nn.Conv2d(v, cfg[k] * 4, kernel_size=3, padding=1)]
        conf_layers += [nn.Conv2d(v, cfg[k] * num_classes, kernel_size=3, padding=1)]

    return (loc_layers, conf_layers)


base = {
    "300": [
        64,
        64,
        "M",
        128,
        128,
        "M",
        256,
        256,
        256,
        "C",
        512,
        512,
        512,
        "M",
        512,
        512,
        512,
    ],
    "512": [],
}
extras = {
    "300": [256, "S", 512, 128, "S", 256, 128, 256, 128, 256],
    "512": [],
}
mbox = {
    "300": [4, 4, 6, 6, 6],  # number of boxes per feature map location
    "512": [],
}


def build_ssd(phase, size=300, num_classes=21):
    if phase != "test" and phase != "train":
        print("ERROR: Phase: " + phase + " not recognized")
        return
    if size != 300:
        print(
            "ERROR: You specified size "
            + repr(size)
            + ". However, "
            + "currently only SSD300 (size=300) is supported!"
        )
        return
    head_fpn = multibox_fpn(mbox[str(size)], num_classes)
    from data.config import LIM

    return SSD_LIM(phase, size, vgg(base[str(size)], 3), num_classes, head_fpn, LIM)


class FeaturePyramidNetwork(nn.Module):
    def __init__(self, C3_size, C4_size, C5_size, feature_size=256):
        super(FeaturePyramidNetwork, self).__init__()

        # upsample C5 to get P5 from the FPN paper
        self.P5_1 = nn.Conv2d(C5_size, feature_size, kernel_size=1, stride=1, padding=0)

        self.P5_upsampled = nn.Upsample(scale_factor=2, mode="nearest")
        self.P5_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=1, padding=1
        )

        # add P5 elementwise to C4
        self.P4_1 = nn.Conv2d(C4_size, feature_size, kernel_size=1, stride=1, padding=0)

        self.P4_upsampled = nn.Upsample(scale_factor=2, mode="nearest")
        self.P4_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=1, padding=1
        )

        # add P4 elementwise to C3
        self.P3_1 = nn.Conv2d(C3_size, feature_size, kernel_size=1, stride=1, padding=0)
        self.P3_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=1, padding=1
        )

        # "P6 is obtained via a 3x3 stride-2 conv on C5"
        self.P6 = nn.Conv2d(C5_size, feature_size, kernel_size=3, stride=2, padding=1)

        # "P7 is computed by applying ReLU followed by a 3x3 stride-2 conv on P6"
        self.P7_1 = nn.ReLU()
        self.P7_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=2, padding=1
        )

    def forward(self, inputs):
        C3, C4, C5 = inputs

        P5_x = self.P5_1(C5)
        P5_upsampled_x = self.P5_upsampled(P5_x)
        P5_x = self.P5_2(P5_x)

        P4_x = self.P4_1(C4)
        P4_x = P5_upsampled_x + P4_x
        P4_upsampled_x = self.P4_upsampled(P4_x)[:, :, :-1, :-1]
        P4_x = self.P4_2(P4_x)

        P3_x = self.P3_1(C3)
        P3_x = P3_x + P4_upsampled_x
        P3_x = self.P3_2(P3_x)

        P6_x = self.P6(C5)

        P7_x = self.P7_1(P6_x)
        P7_x = self.P7_2(P7_x)
        return [P3_x, P4_x, P5_x, P6_x, P7_x]


class DenseFeaturePyramidNetwork(nn.Module):
    def __init__(self, C3_size, C4_size, C5_size, feature_size=256):
        super(DenseFeaturePyramidNetwork, self).__init__()

        # upsample C5 to get P5 from the FPN paper
        self.P5_1 = nn.Conv2d(C5_size, feature_size, kernel_size=1, stride=1, padding=0)
        self.P5_1_dual = nn.Conv2d(
            C5_size, feature_size, kernel_size=1, stride=1, padding=0
        )
        self.P5_upsampled_1 = nn.Upsample(scale_factor=2, mode="nearest")
        self.P5_upsampled_2 = nn.Upsample(scale_factor=2, mode="nearest")
        self.P5_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=1, padding=1
        )

        # add P5 elementwise to C4
        self.P4_1 = nn.Conv2d(C4_size, feature_size, kernel_size=1, stride=1, padding=0)
        self.P4_1_dual = nn.Conv2d(
            C4_size, feature_size, kernel_size=1, stride=1, padding=0
        )
        self.P4_upsampled_1 = nn.Upsample(scale_factor=2, mode="nearest")
        self.P4_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=1, padding=1
        )

        # add P4 elementwise to C3
        self.P3_1 = nn.Conv2d(C3_size, feature_size, kernel_size=1, stride=1, padding=0)
        self.P3_1_dual = nn.Conv2d(
            C3_size, feature_size, kernel_size=1, stride=1, padding=0
        )
        self.P3_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=1, padding=1
        )

        # "P6 is obtained via a 3x3 stride-2 conv on C5"
        self.P6 = nn.Conv2d(C5_size, feature_size, kernel_size=3, stride=2, padding=1)

        # "P7 is computed by applying ReLU followed by a 3x3 stride-2 conv on P6"
        self.P7_1 = nn.ReLU()
        self.P7_2 = nn.Conv2d(
            feature_size, feature_size, kernel_size=3, stride=2, padding=1
        )

        self.corner_proc_C3 = Boundary_Aggregation(256)
        self.corner_proc_C4 = Boundary_Aggregation(512)
        self.corner_proc_C5 = Boundary_Aggregation(1024)

        self.conv_p3_to_p4 = nn.Conv2d(256, 256, kernel_size=3, stride=2, padding=1)
        self.conv_p4_to_p5 = nn.Conv2d(256, 256, kernel_size=2, stride=2, padding=0)
        self.conv_p3_to_p5 = nn.Conv2d(256, 256, kernel_size=2, stride=2, padding=0)

        self.gamma_3 = nn.Parameter(torch.zeros(1))
        self.gamma_4 = nn.Parameter(torch.zeros(1))
        self.gamma_5 = nn.Parameter(torch.zeros(1))

    def forward(self, inputs):
        C3, C4, C5 = inputs  # 150，75,38,19

        C3_BA = self.corner_proc_C3(C3)
        C4_BA = self.corner_proc_C4(C4)
        C5_BA = self.corner_proc_C5(C5)

        P5_x = self.P5_1(C5)
        P5_upsampled_x_1 = self.P5_upsampled_1(P5_x)  # 38
        P5_upsampled_x_2 = self.P5_upsampled_2(P5_upsampled_x_1)[:, :, :-1, :-1]  # 75
        # P5_upsampled_x_3 = self.P5_upsampled_3(P5_upsampled_x_2)#150
        P5_x = self.P5_2(P5_x)

        P4_x = self.P4_1(C4)
        P4_x = P4_x + P5_upsampled_x_1  # 38
        P4_upsampled_x_1 = self.P4_upsampled_1(P4_x)[:, :, :-1, :-1]  # 75
        # P4_upsampled_x_2 = self.P4_upsampled_2(P4_upsampled_x_1)#150
        P4_x = self.P4_2(P4_x)

        P3_x = self.P3_1(C3)
        P3_x = P3_x + P4_upsampled_x_1 + P5_upsampled_x_2  # 75
        # P3_upsampled_x_1 = self.P3_upsampled(P3_x)  # 150
        P3_x = self.P3_2(P3_x)

        P3_dual = self.P3_1_dual(C3_BA)
        P3_downsample_x_1 = self.conv_p3_to_p4(P3_dual)
        P3_downsample_x_2 = self.conv_p3_to_p5(P3_downsample_x_1)

        P4_dual = self.P4_1_dual(C4_BA)
        P4_dual = P4_dual + P3_downsample_x_1
        P4_downsample_x_1 = self.conv_p4_to_p5(P4_dual)

        P5_dual = self.P5_1_dual(C5_BA)
        P5_dual = P5_dual + P4_downsample_x_1 + P3_downsample_x_2

        P6_x = self.P6(C5)  # 10

        P7_x = self.P7_1(P6_x)
        P7_x = self.P7_2(P7_x)  # 5

        O3_x = self.gamma_3 * P3_dual + (1 - self.gamma_3) * P3_x
        O4_x = self.gamma_4 * P4_dual + (1 - self.gamma_4) * P4_x
        O5_x = self.gamma_5 * P5_dual + (1 - self.gamma_5) * P5_x

        return [O3_x, O4_x, O5_x, P6_x, P7_x]


class RegressionModel(nn.Module):
    def __init__(self, num_features_in, num_anchors=9, feature_size=256):
        super(RegressionModel, self).__init__()

        self.conv1 = nn.Conv2d(num_features_in, feature_size, kernel_size=3, padding=1)
        self.act1 = nn.ReLU()
        self.conv2 = nn.Conv2d(feature_size, feature_size, kernel_size=3, padding=1)
        self.act2 = nn.ReLU()
        self.conv3 = nn.Conv2d(feature_size, feature_size, kernel_size=3, padding=1)
        self.act3 = nn.ReLU()
        self.conv4 = nn.Conv2d(feature_size, feature_size, kernel_size=3, padding=1)
        self.act4 = nn.ReLU()
        self.output = nn.Conv2d(feature_size, num_anchors * 4, kernel_size=3, padding=1)

    def forward(self, x):
        out = self.conv1(x)
        out = self.act1(out)

        out = self.conv2(out)
        out = self.act2(out)

        out = self.conv3(out)
        out = self.act3(out)

        out = self.conv4(out)
        out = self.act4(out)

        out = self.output(out)

        # out is B x C x W x H, with C = 4*num_anchors
        out = out.permute(0, 2, 3, 1)
        return out.contiguous().view(out.shape[0], -1, 4)
