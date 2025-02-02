from dataclasses import dataclass

from enum import Enum, auto
from pathlib import Path

__all__ = [
    "Label",
    "BoundingBox",
    "Metadata",
    "BubbleViewConstraints",
    "BodyPart",
    "Keypoint",
    "ClickPoint",
    "Annotation",
]


@dataclass(frozen=True)
class Label:
    id: int
    name: str


@dataclass(frozen=True)
class Metadata:
    project_name: str
    author: str
    licence: str


@dataclass(frozen=True)
class BubbleViewConstraints:
    bubble_radius: float
    click_limit: float
    blur_amount: float


@dataclass(frozen=True)
class BoundingBox:
    id: int
    label: Label
    start_x: float
    start_y: float
    end_x: float
    end_y: float

    @property
    def area(self) -> float:
        return max(0.0, (self.end_x - self.start_x)) * max(0.0, (self.end_y - self.start_y))


class BodyPart(Enum):
    NOSE = 0
    EYE_L = auto()
    EYE_R = auto()
    EAR_L = auto()
    EAR_R = auto()
    SHOULDER_L = auto()
    SHOULDER_R = auto()
    ELBOW_L = auto()
    ELBOW_R = auto()
    WRIST_L = auto()
    WRIST_R = auto()
    HIP_L = auto()
    HIP_R = auto()
    KNEE_L = auto()
    KNEE_R = auto()
    ANKLE_L = auto()
    ANKLE_R = auto()


@dataclass(frozen=True)
class Keypoint:
    id: int
    body_part: BodyPart
    x: float
    y: float


@dataclass(frozen=True)
class ClickPoint:
    id: int
    x: float
    y: float
    radius: float

    @property
    def position(self) -> tuple[float, float]:
        return self.x, self.y


@dataclass(frozen=True)
class Annotation:
    annotation_id: int
    image: Path
    image_labels: list[Label] = None
    click_points: list[ClickPoint] = None
    key_points: list[Keypoint] = None
    bounding_boxes: list[BoundingBox] = None
