import 'dart:ui';

import 'package:open_image_annotator/domain/dataset/label.dart';

class BBox {
  final int id;
  final Offset start;
  final Offset end;
  final Label? label;

  BBox({
    required this.start,
    required this.end,
    required this.id,
    this.label,
  });

  BBox copyWith({
    int? id,
    Offset? start,
    Offset? end,
    Label? label,
  }) {
    return BBox(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      label: label ?? this.label,
    );
  }

  BBox deepCopy() {
    return BBox(
      id: id,
      label: label?.deepCopy(),
      start: start,
      end: end,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "start_x": start.dx,
      "start_y": start.dy,
      "end_x": end.dx,
      "end_y": end.dy,
      "label": label?.toMap(),
    };
  }

  factory BBox.fromMap(Map<String, dynamic> map) {
    return BBox(
      id: map['id'] as int,
      start: Offset(
        map['start_x'] as double,
        map['start_y'] as double,
      ),
      end: Offset(
        map['end_x'] as double,
        map['end_y'] as double,
      ),
      label: map['label'] != null
          ? Label.fromMap(map['label'] as Map<String, dynamic>)
          : null,
    );
  }
}
