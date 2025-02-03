import 'dart:convert';
import 'dart:io';

extension FileExtension on File {
  bool get isImageFile {
    final extensions = ['jpg', 'jpeg', 'png', 'bmp', 'gif'];
    final ext = path.split('.').last.toLowerCase();
    return extensions.contains(ext);
  }

  Future<void> writeAsJson(Map<String, dynamic> map) async {
    await writeAsString(jsonEncode(map));
  }

  Future<Map<String, dynamic>> readAsJsonToMap() async {
    final jsonString = await readAsString();

    return jsonDecode(jsonString);
  }
}
