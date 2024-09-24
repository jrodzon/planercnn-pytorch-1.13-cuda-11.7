## Original repository
Original repository and README see [README](https://github.com/nku-zhichengzhang/PlaneSeg/README.md)

## Thanks to WeihongPan
With the help of [WeihongPan](https://github.com/WeihongPan)
and based on [his PlaneRCNN fork](https://github.com/WeihongPan/planercnn-pytorch1.10.1_cuda11.3/tree/cuda11.3_pytorch1.10?tab=readme-ov-file)
several modifications have been done for pytorch=1.13.1 with cuda=11.7

Unfortunately for me, his requirements.txt wasn't working and I was not able to setup the environment that way.
Because of that I switched to only use conda environment
and I have prepared `environment.yml` file.

## Installation

Create conda environment based on the file [environment.yml](./environment.yml):
```shell
conda env create -f environment.yml
```
> :warning: **This operation may take several minutes**

Activate the new environment:
```shell
conda activate planercnn_pytorch_1_13_cuda_11_7
```

Install `h5py` later, because for some reason with it, conda is not able to solve the environment within a reasonable amount of time:
```shell
conda install h5py=3.7.0
```

Install [RoIAlign](https://github.com/longcw/RoIAlign.pytorch) from the author's instructions
or with [the convenience script](./install_roi_align.sh):
```shell
./install_roi_align.sh
```

## Frequent installation errors:

### On cuda error with version mismatch when installing RoIAlign

```shell
The detected CUDA version (X.Y) mismatches the version that was used to compile PyTorch (11.7). Please make sure to use the same CUDA versions
```

Unfortunately, you must have the cuda 11.7 also locally (not only in the conda environment),
because RoIAlign installation fails without it.

### On RoIAlign error - it is not a problem, the project works fine:
```shell
apply() got an unexpected keyword argument 'transform_fpcoor'
```
Check this solution:
Replace in file tests/test2.py line 28:
```python
print(RoIAlign.apply(image_torch, boxes, box_index, 3, 3, transform_fpcoor=True))
```
with:
```python
roi_align =RoIAlign(3, 3, transform_fpcoor=True)
print(roi_align(image_torch, boxes, box_index))
```
Source:
https://github.com/longcw/RoIAlign.pytorch/issues/43

### Dependencies
In order to get rid of pre-compilation for `roialign` and `nms`, and to make it suitable for higher pytorch version, I did several changes as below:
#### RoIAlign
install RoIAlign for pytorch1.0 from [here](https://github.com/longcw/RoIAlign.pytorch)

in file `models/model.py`, change
```py
from roialign.roi_align.crop_and_resize import CropAndResizeFunction
```
to
```py
from roi_align import CropAndResize
```
and replace every `CropAndResizeFunction` with `CropAndResize` without changing its usage
#### nms
in file `models/model.py`, change
```py
from nms.nms_wrapper import nms
```
to
```py
from torchvision.ops import nms
```
Notice that there are several differences between the usage of these two `nms` functions which I have changed in `model.py`
