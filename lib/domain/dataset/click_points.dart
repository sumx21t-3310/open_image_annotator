import 'dart:ui';

class ClickPoint implements Comparable<ClickPoint> {
  final int id;
  final Offset position;
  final double radius;

  ClickPoint({required this.id, required this.position, required this.radius});

  ClickPoint copyWith({
    int? id,
    Offset? position,
    double? radius,
  }) {
    return ClickPoint(
      id: id ?? this.id,
      position: position ?? this.position,
      radius: radius ?? this.radius,
    );
  }

  ClickPoint deepCopy() {
    return ClickPoint(
      id: id,
      position: position,
      radius: radius,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'x': position.dx,
      'y': position.dy,
      'radius': radius,
    };
  }

  factory ClickPoint.fromMap(Map<String, dynamic> map) {
    return ClickPoint(
      id: map["id"] as int,
      position: Offset(
        map["x"] as double,
        map["y"] as double,
      ),
      radius: map["radius"] as double,
    );
  }

  @override
  int compareTo(ClickPoint other) {
    return id.compareTo(other.id);
  }
}
