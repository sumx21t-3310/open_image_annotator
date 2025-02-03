import random

import cv2
import matplotlib.pyplot as plt
import numpy as np
import torch
from PIL import Image

from open_image_annotator_dataset.types import *
from ._dataset_base import OpenImageAnnotatorDatasetBase
from torchvision.transforms.v2 import *

__all__ = [
    "OpenImageAnnotatorBubbleViewDataset",
    "generate_saliency_map"
]


class OpenImageAnnotatorBubbleViewDataset(OpenImageAnnotatorDatasetBase):
    def __init__(self, data_path, image_transform: Transform = ToTensor(), map_transform: Transform = ToTensor()):
        super().__init__(data_path)
        self.image_transform = image_transform
        self.map_transform = map_transform

        self.cache_images: dict[int, tuple[torch.Tensor, torch.Tensor]] = {}

    def __getitem__(self, item) -> tuple[torch.Tensor, torch.Tensor]:
        if item in self.cache_images:
            image, ground_truth = self.cache_images[item]
            return image, ground_truth

        annotation = self.annotations[item]
        image = Image.open(annotation.image)
        saliency_map = annotation.click_points
        ground_truth = generate_saliency_map(saliency_map, image.size, point_intensity=0.25, blur_radius=100)

        if self.image_transform is not None:
            image = self.image_transform(image)

        if self.map_transform is not None:
            ground_truth = self.map_transform(ground_truth)

        self.cache_images[item] = (image, ground_truth)

        return image, ground_truth


def clamp(value, min_value: float = 0, max_value: float = 1):
    return max(min_value, min(value, max_value))


def generate_saliency_map(coordinates: list[ClickPoint],
                          image_size=(500, 500),
                          point_intensity: float = 0.125,
                          blur_radius=51,
                          magnification_rate: float = 1.5,
                          ) -> Image:
    point_intensity = clamp(point_intensity)
    width, height = image_size

    short_side = min(width, height)

    saliency_map = np.zeros((height, width), dtype=np.float32)

    for clickpoint in coordinates:
        if 0 <= clickpoint.x < width and 0 <= clickpoint.y < height:
            circle_radius = int((clickpoint.radius / 100.0) * short_side)
            if circle_radius < 1:
                circle_radius = 1

            overlay = np.zeros_like(saliency_map, dtype=np.float32)

            cv2.circle(overlay,

                       (int(clickpoint.x), int(clickpoint.y)),
                       circle_radius * magnification_rate,
                       (point_intensity),
                       thickness=-1)

            saliency_map = np.clip(saliency_map + overlay, 0, 1)
        else:
            print(f"座標 ({clickpoint.x}, {clickpoint.y}) は画像サイズ {image_size} の範囲外です。")

    if blur_radius > 0:
        if blur_radius % 2 == 0:
            blur_radius += 1

        saliency_map = cv2.GaussianBlur(saliency_map, (blur_radius, blur_radius), 0)

    saliency_map = cv2.normalize(saliency_map, None, 0, 255, cv2.NORM_MINMAX)
    saliency_map = saliency_map.astype(np.uint8)

    return Image.fromarray(saliency_map, "L")


if __name__ == '__main__':
    width = 256
    height = 256

    coordinates = [ClickPoint(i, random.randint(0, width - 1), random.randint(0, height - 1), 5) for i in range(100)]

    saliency_map = generate_saliency_map(coordinates, image_size=(width, height), blur_radius=51)

    plt.figure(figsize=(8, 6))
    plt.imshow(saliency_map)
    plt.title('saliency map')
    plt.axis('off')
    plt.show()
