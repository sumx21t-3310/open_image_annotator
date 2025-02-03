import 'package:open_image_annotator/domain/dataset/label.dart';

class Metadata {
  final String projectName;
  final String author;
  final String license;

  const Metadata({
    this.projectName = "undefined",
    this.author = "",
    this.license = "MIT",
  });

  Metadata copyWith({
    String? projectName,
    String? author,
    String? license,
    List<Label>? projectLabels,
  }) {
    return Metadata(
      projectName: projectName ?? this.projectName,
      author: author ?? this.author,
      license: license ?? this.license,
    );
  }

  Metadata deepCopy() {
    return Metadata(
      projectName: projectName,
      author: author,
      license: license,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "project_name": projectName,
      "author": author,
      "licence": license,
    };
  }

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      projectName: map['project_name'] as String? ?? "undefined",
      author: map['author'] as String? ?? "",
      license: map['licence'] as String? ?? "MIT",
    );
  }

  factory Metadata.fromLabelsList(
    List<String> labels, {
    String projectName = "undefined",
    String author = "",
    String license = "MIT",
  }) {
    return Metadata(
      projectName: projectName,
      author: author,
      license: license,
    );
  }
}
