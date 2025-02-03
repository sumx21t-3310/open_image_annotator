import 'dart:io';

import 'package:open_image_annotator/domain/dataset/dataset.dart';


abstract class DatasetHandler {
  Future<Dataset> open(File file);

  Future<void> save(Dataset project, File file);
}