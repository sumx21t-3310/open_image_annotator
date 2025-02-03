import 'package:flutter/animation.dart';

import 'body_part.dart';

class KeyPoint implements Comparable<KeyPoint> {
  final int id;
  final Offset position;
  final BodyPart bodyPart;

  KeyPoint({required this.id, required this.position, required this.bodyPart});

  KeyPoint copyWith({
    int? id,
    Offset? position,
    BodyPart? bodyPart,
  }) {
    return KeyPoint(
      id: id ?? this.id,
      position: position ?? this.position,
      bodyPart: bodyPart ?? this.bodyPart,
    );
  }

  KeyPoint deepCopy() {
    return KeyPoint(
      id: id,
      position: position,
      bodyPart: bodyPart,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position': {'dx': position.dx, 'dy': position.dy},
      'body_part': bodyPart.index,
    };
  }

  factory KeyPoint.fromMap(Map<String, dynamic> map) {
    return KeyPoint(
      id: map['id'] as int,
      position: Offset(
        map['x'] as double,
        map['y'] as double,
      ),
      bodyPart: BodyPart.values[map['body_part'] as int],
    );
  }

  @override
  int compareTo(KeyPoint other) {
    return id.compareTo(other.id);
  }
}