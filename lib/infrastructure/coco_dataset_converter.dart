import 'dart:io';

import 'package:open_image_annotator/application/extensions/file_extensions.dart';
import 'package:open_image_annotator/domain/dataset/dataset.dart';
import 'package:open_image_annotator/domain/dataset_converter.dart';

class CocoDatasetConverter implements DatasetHandler {
  @override
  Future<Dataset> open(File path) async {
    final map = path.readAsJsonToMap();

    return Dataset();
  }

  @override
  Future<void> save(Dataset project, File path) async {}
}
