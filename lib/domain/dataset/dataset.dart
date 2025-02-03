import 'dart:io';

import 'package:open_image_annotator/domain/dataset/annotation.dart';
import 'package:open_image_annotator/domain/dataset/bubble_view_constraints.dart';
import 'package:open_image_annotator/domain/dataset/label.dart';
import 'package:open_image_annotator/domain/dataset/metadata.dart';

class Dataset {
  final Metadata metaData;
  final List<Annotation> annotations;
  final List<Label> projectLabels;
  final BubbleViewConstraints bubbleViewConstraints;

  Dataset({
    this.metaData = const Metadata(),
    this.annotations = const [],
    this.projectLabels = const [],
    this.bubbleViewConstraints = const BubbleViewConstraints(),
  });

  Dataset.fromImages(
    List<File> images, {
    this.projectLabels = const [],
    this.metaData = const Metadata(),
    this.bubbleViewConstraints = const BubbleViewConstraints(),
  }) : annotations = images
            .asMap()
            .entries
            .map((image) => Annotation(id: image.key, image: image.value))
            .toList();

  factory Dataset.fromMap(Map<String, dynamic> map) {
    return Dataset();
  }

  Map<String, Object> toMap({String root = ""}) {
    return {
      "metadata": metaData.toMap(),
      "project_labels": projectLabels.map((label) => label.toMap()).toList(),
      "bubble_view_constraints": bubbleViewConstraints.toMap(),
      "annotations": annotations.map((anno) => anno.toMap(root: root)).toList(),
    };
  }

  Dataset copyWith({
    Metadata? metaData,
    List<Annotation>? annotations,
    List<Label>? projectLabels,
    BubbleViewConstraints? bubbleViewConstraints,
  }) {
    return Dataset(
      metaData: metaData ?? this.metaData,
      annotations: annotations ?? [...this.annotations],
      projectLabels: projectLabels ?? [...this.projectLabels],
      bubbleViewConstraints:
          bubbleViewConstraints ?? this.bubbleViewConstraints,
    );
  }
}
