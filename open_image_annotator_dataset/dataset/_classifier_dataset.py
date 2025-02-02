from pathlib import Path

import torch
from PIL import Image
from torchvision.transforms.v2 import Transform, ToTensor

from open_image_annotator_dataset.dataset import OpenImageAnnotatorDatasetBase

__all__ = ['OpenImageAnnotatorDatasetBase']


class OpenImageAnnotatorClassifierDataset(OpenImageAnnotatorDatasetBase):
    def __init__(self, data_path: Path | str, image_transform: Transform = ToTensor()) -> None:
        super().__init__(Path(data_path))
        self.image_transform = image_transform

    def __getitem__(self, item) -> tuple[torch.Tensor, torch.Tensor]:
        image = Image.open(self.annotations[item].image).convert('RGB')
        image = self.image_transform(image)
        labels = [label.id for label in self.annotations[item].image_labels]

        return image, torch.tensor(labels).long()


class OpenImageAnnotatorMultiLabelClassifierDataset(OpenImageAnnotatorDatasetBase):
    def __getitem__(self, item):
        pass
