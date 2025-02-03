import 'dart:io';

import 'package:open_image_annotator/domain/dataset/bbox.dart';
import 'package:open_image_annotator/domain/dataset/click_points.dart';
import 'package:open_image_annotator/domain/dataset/key_points.dart';
import 'package:open_image_annotator/domain/dataset/label.dart';
import 'package:path/path.dart';

class Annotation implements Comparable {
  final int id;
  File image;
  List<KeyPoint> keyPoints;
  List<ClickPoint> clickPoints;
  List<Label> imageLabels;
  List<BBox> bounds;

  Annotation({
    required this.id,
    required this.image,
    this.imageLabels = const [],
    this.bounds = const [],
    this.clickPoints = const [],
    this.keyPoints = const [],
  });

  Annotation copyWith({
    int? id,
    File? image,
    List<KeyPoint>? keyPoints,
    List<ClickPoint>? clickPoints,
    List<Label>? imageLabels,
    List<BBox>? bounds,
  }) {
    return Annotation(
      id: id ?? this.id,
      image: image ?? this.image,
      keyPoints: keyPoints ?? [...this.keyPoints],
      clickPoints: clickPoints ?? [...this.clickPoints],
      imageLabels: imageLabels ?? [...this.imageLabels],
      bounds: bounds ?? [...this.bounds],
    );
  }

  Map<String, dynamic> toMap({String root = ""}) {
    return {
      'id': id,
      'image': posix.relative(image.path, from: root),
      'key_points': keyPoints.map((kp) => kp.toMap()).toList(),
      'click_points': clickPoints.map((cp) => cp.toMap()).toList(),
      'image_labels': imageLabels.map((il) => il.toMap()).toList(),
      'bounds': bounds.map((b) => b.toMap()).toList(),
    };
  }

  factory Annotation.fromMap(Map<String, dynamic> map, File directory) {
    try {
      final imagePath = map['image'] as String;

      return Annotation(
        id: map['id'] as int,
        image: File(imagePath),
        keyPoints: List<Map<String, dynamic>>.from(map['key_points'] ?? [])
            .map((kp) => KeyPoint.fromMap(kp))
            .toList(),
        clickPoints: List<Map<String, dynamic>>.from(map['click_points'] ?? [])
            .map((cp) => ClickPoint.fromMap(cp))
            .toList(),
        imageLabels: List<Map<String, dynamic>>.from(map['image_labels'] ?? [])
            .map((il) => Label.fromMap(il))
            .toList(),
        bounds: List<Map<String, dynamic>>.from(map['bounds'] ?? [])
            .map((b) => BBox.fromMap(b))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  int compareTo(covariant Annotation other) {
    return id.compareTo(other.id);
  }
}
