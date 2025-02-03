import 'dart:io';

import 'package:open_image_annotator/application/extensions/file_extensions.dart';
import 'package:open_image_annotator/domain/dataset/annotation.dart';
import 'package:open_image_annotator/domain/dataset/bbox.dart';
import 'package:open_image_annotator/domain/dataset/bubble_view_constraints.dart';
import 'package:open_image_annotator/domain/dataset/click_points.dart';
import 'package:open_image_annotator/domain/dataset/dataset.dart';
import 'package:open_image_annotator/domain/dataset/label.dart';
import 'package:open_image_annotator/domain/dataset/metadata.dart';
import 'package:open_image_annotator/domain/dataset_converter.dart';
import 'package:path/path.dart';

class JsonDatasetHandler implements DatasetHandler {
  @override
  Future<Dataset> open(File file) async {
    final map = await file.readAsJsonToMap();

    final metaData = map["metadata"];
    final constraints = map["bubble_view_constraints"];
    final annotations = (map["annotations"] as List<dynamic>)
        .map((x) => x as Map<String, dynamic>)
        .map((annotation) {
      int id = annotation["id"];
      String imagePath = join(file.parent.path, annotation["image"]);
      final clickPoints = annotation["click_points"] as List;
      final imageLabels = annotation["image_labels"] as List;
      final bboxes = annotation["bounds"] as List;

      return Annotation(
        id: id,
        image: File(imagePath),
        clickPoints: clickPoints.map((e) => ClickPoint.fromMap(e)).toList(),
        imageLabels: imageLabels.map((x) => Label.fromMap(x)).toList(),
        bounds: bboxes.map((x) => BBox.fromMap(x)).toList(),
      );
    }).toList();

    return Dataset(
      metaData: Metadata.fromMap(metaData),
      bubbleViewConstraints: BubbleViewConstraints.fromMap(constraints),
      annotations: annotations,
    );
  }

  @override
  Future<void> save(Dataset project, File file) async {
    final map = project.toMap(root: file.parent.path);

    file.writeAsJson(map);
  }
}
