class Label {
  final int id;
  final String name;

  Label({required this.id, required this.name});

  Label copyWith({
    int? id,
    String? name,
  }) {
    return Label(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Label deepCopy() {
    return Label(
      id: id,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  factory Label.fromMap(Map<String, dynamic> map) {
    return Label(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}