from PIL import Image
from torchvision.transforms.v2 import Transform

from ._dataset_base import OpenImageAnnotatorDatasetBase

__all__ = ["OpenImageAnnotatorDetectionDataset"]

class OpenImageAnnotatorDetectionDataset(OpenImageAnnotatorDatasetBase):
    def __init__(self, path, image_transform: Transform):
        super().__init__(path)
        self.image_transform = image_transform

    def __getitem__(self, item):
        image = Image.open(self.annotations[item].image)
        bbox = self.annotations[item].bounding_boxes

        self.image_transform(image)

        return image, bbox

    def _get_bbox(self, item):
        bbox = self.annotations[item].bounding_boxes
        return bbox
