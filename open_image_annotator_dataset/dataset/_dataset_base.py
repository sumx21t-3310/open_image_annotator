import json
from abc import ABC, abstractmethod
from pathlib import Path

from torch.utils.data import Dataset
from open_image_annotator_dataset.types import *

__all__ = ['OpenImageAnnotatorDatasetBase', 'parse_dataset_file']


class OpenImageAnnotatorDatasetBase(Dataset, ABC):
    def __init__(self, data_path: str | Path):
        data_path = Path(data_path)
        metadata, constraints, annotations = parse_dataset_file(data_path)

        self.annotations = annotations
        self.metadata = metadata
        self.constraints = constraints

    @abstractmethod
    def __getitem__(self, item):
        pass

    def __len__(self):
        return len(self.annotations)


def parse_dataset_file(file_path: str | Path):
    file_path = Path(file_path)
    with file_path.open() as f:
        json_data = json.load(f)
        metadata = Metadata(**json_data['metadata'])
        constraints = BubbleViewConstraints(**json_data['bubble_view_constraints'])
        root = Path(file_path).parent
        annotations = []

        for annotation in json_data['annotations']:
            annotation_id = annotation['id']
            image = Path(root / annotation['image'].replace(r"\\", "/"))
            clickpoints = [ClickPoint(**cp) for cp in annotation['click_points']]
            image_labels = [Label(**il) for il in annotation['image_labels']]
            bounds = [BoundingBox(**bbox) for bbox in annotation['bounds']]

            result = Annotation(annotation_id=annotation_id,
                                image=image,
                                image_labels=image_labels,
                                click_points=clickpoints,
                                bounding_boxes=bounds,
                                )
            annotations.append(result)

    return metadata, constraints, annotations


if __name__ == '__main__':
    path = input("Enter path to dataset: ").replace("'", "").replace('"', "")
    metadata, constraints, annotations = parse_dataset_file(path)
    for annotation in annotations:
        print(annotation.image)
