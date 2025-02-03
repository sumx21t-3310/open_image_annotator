import 'dart:io';

import 'package:open_image_annotator/application/editor/editor_state.dart';
import 'package:open_image_annotator/application/extensions/file_extensions.dart';
import 'package:open_image_annotator/domain/dataset/annotation.dart';
import 'package:open_image_annotator/domain/dataset/click_points.dart';
import 'package:open_image_annotator/domain/dataset/dataset.dart';
import 'package:open_image_annotator/domain/dataset/label.dart';
import 'package:open_image_annotator/infrastructure/json_dataset_converter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectNotifier extends StateNotifier<Dataset?> {
  ProjectNotifier(super.state, this.ref);

  File? _file;

  final JsonDatasetHandler converter = JsonDatasetHandler();
  final Ref ref;

  bool get isProjectOpen => state != null;

  void createProject(Dataset result) => state = result;

  Future openProject() async {
    final selectFiles = await FilePicker.platform.pickFiles(
      allowedExtensions: ["anno", "json"],
      type: FileType.custom,
    );

    if (selectFiles == null) return;

    _file = File(selectFiles.files.single.path!);
    state = await converter.open(_file!);
  }

  Future<void> saveProject() async {
    if (state == null) return;

    // プロジェクト名を定義
    final fileName = "${state?.metaData.projectName ?? "undefined"}.anno";

    // 保存先のディレクトリを選択
    final savePath = await FilePicker.platform.saveFile(
      fileName: fileName,
      allowedExtensions: ["anno", "json"],
      type: FileType.custom,
    );

    // 保存先が選択されなかった場合
    if (savePath == null) return;
    if (state == null) return;
    try {
      await converter.save(state!, File(savePath));
    } catch (e) {
      debugPrint("ファイル保存中にエラーが発生しました: $e");
    }
  }

  Future<void> pickFolder() async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;

    final dir = Directory(selectedDirectory);

    final images = dir
        .listSync()
        .where((item) => item is File && item.isImageFile)
        .map((item) => File(item.path))
        .toList();

    addAnnotations(images);
  }

  Future<void> pickImage() async {
    final results = await FilePicker.platform.pickFiles(
      dialogTitle: "select images",
      type: FileType.image,
      allowMultiple: true,
    );

    addAnnotations(
      results?.files.map((f) => File(f.path!)).toList() ?? [],
    );
  }

  void addAnnotations(List<File>? newImages) {
    final annotations = state?.annotations;
    if (newImages == null) return;
    if (annotations == null) return;

    state = state?.copyWith(annotations: [
      ...annotations,
      ...newImages.asMap().entries.map((e) {
        final offset = annotations.isEmpty ? 1 : annotations.last.id + 1;
        return Annotation(id: offset + e.key, image: e.value);
      })
    ]);
  }

  void deleteImage(int index) {
    if (state == null) return;
    final annotations = state?.annotations;
    if (annotations == null || annotations.isEmpty) return;
    if (index >= 0 && index < state!.annotations.length) {
      annotations.removeAt(index);
    }

    state = state?.copyWith(annotations: [...annotations]);
  }

  void addImageLabels(Label label, int index) {
    final annotations = state?.annotations;

    if (annotations == null) return;

    final labels = annotations[index].imageLabels;

    if (labels.contains(label)) return;

    annotations[index].imageLabels = [...labels, label];

    state = state?.copyWith(annotations: annotations);
    ref.read(editorStateProvider.notifier).changeImageAt(index);
  }

  void addProjectLabels(String label) {
    if (state == null) return;

    final projectLabels = state!.projectLabels;

    final newId = projectLabels.isEmpty ? 1 : projectLabels.last.id + 1;

    state = state?.copyWith(
      projectLabels: [...projectLabels, Label(id: newId, name: label)],
    );
  }

  void removeProjectLabels(int index) {
    if (state == null) return;

    final projectLabels = state!.projectLabels;
    projectLabels.removeAt(index);

    state = state?.copyWith(projectLabels: [...projectLabels]);
  }

  void removeImageLabels(Annotation annotation, Label label) {
    if (state == null) return;
    final annotations = state!.annotations;
    final index = annotations.indexWhere((e) => e.id == annotation.id);

    final imageLabels = annotations[index].imageLabels;
    imageLabels.removeWhere((x) => x.id == label.id);
    annotations[index].imageLabels = [...imageLabels];

    state = state?.copyWith(annotations: [...annotations]);
  }

  void addClickPoint(TapDownDetails details, int index) {
    final annotations = state?.annotations;
    final constraints = state?.bubbleViewConstraints;

    if (annotations == null) return;
    final oldData = annotations[index].clickPoints;
    if (oldData.length > (constraints?.clickLimit ?? 0)) {
      ref.read(editorStateProvider.notifier).nextImage();
      return;
    }
    if (oldData.isNotEmpty) {
      oldData.sort();
    }
    final newId = oldData.isEmpty ? 1 : oldData.last.id + 1;

    final clickPoints = annotations[index].clickPoints;
    annotations[index].clickPoints = [
      ...clickPoints,
      ClickPoint(
          id: newId,
          position: details.localPosition,
          radius: constraints!.bubbleRadius)
    ];

    state = state?.copyWith(annotations: [...annotations]);

    ref.read(editorStateProvider.notifier).changeImageAt(index);
  }

  void changeBubbleRadius(double value) {
    final constraints = state?.bubbleViewConstraints;
    if (constraints == null) return;

    state = state?.copyWith(
      bubbleViewConstraints: constraints.copyWith(bubbleRadius: value),
    );
  }

  void changeBubbleClickCountLimit(int value) {
    final constraints = state?.bubbleViewConstraints;
    if (constraints == null) return;
    state = state?.copyWith(
      bubbleViewConstraints: constraints.copyWith(clickLimit: value),
    );
  }

  void changeBlurAmount(double value) {
    final constraints = state?.bubbleViewConstraints;
    if (constraints == null) return;

    state = state?.copyWith(
      bubbleViewConstraints: constraints.copyWith(blurAmount: value),
    );
  }

  void changeProjectName(String projectName) {
    final metadata = state?.metaData;
    if (metadata == null) return;
    state = state?.copyWith(
      metaData: metadata.copyWith(projectName: projectName),
    );
  }

  void changeAuthor(String author) {
    final metadata = state?.metaData;
    if (metadata == null) return;
    state = state?.copyWith(
      metaData: metadata.copyWith(author: author),
    );
  }

  void changeLicense(String license) {
    final metadata = state?.metaData;
    if (metadata == null) return;
    state = state?.copyWith(
      metaData: metadata.copyWith(license: license),
    );
  }
}

final projectProvider = StateNotifierProvider<ProjectNotifier, Dataset?>(
  (ref) => ProjectNotifier(null, ref),
);
