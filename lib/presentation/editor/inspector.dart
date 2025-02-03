import 'package:open_image_annotator/application/editor/editor_state.dart';
import 'package:open_image_annotator/application/editor/project_notifier.dart';
import 'package:open_image_annotator/application/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Inspector extends ConsumerWidget {
  const Inspector({super.key});

  Widget createKeyPointUI() {
    return Container();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(projectProvider);
    final index = ref.watch(editorStateProvider).currentImageIndex;
    final settings = ref.watch(settingsProvider);

    if (project?.annotations.isEmpty ?? true) {
      return Container(color: Colors.black12);
    }
    final annotation = project!.annotations[index];
    final imageLabels = annotation.imageLabels;
    final projectLabels = project.projectLabels.where((e) {
      return annotation.imageLabels.contains(e) == false;
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: settings.initialTileExpanded,
            title: Text("ラベル"),
            children: [
              ...imageLabels.map(
                (label) => ListTile(
                  leading: Text(label.id.toString()),
                  title: Text(label.name),
                  trailing: IconButton(
                    onPressed: () => ref
                        .read(projectProvider.notifier)
                        .removeImageLabels(annotation, label),
                    icon: Icon(Icons.delete),
                  ),
                ),
              ),
              ListTile(
                title: DropdownButton(
                  hint: Text("ラベルを追加"),
                  items: projectLabels
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (item) {
                    if (item == null) return;
                    ref
                        .read(projectProvider.notifier)
                        .addImageLabels(item, index);
                  },
                ),
              )
            ],
          ),
          if (annotation.clickPoints.isNotEmpty)
            ExpansionTile(
              initiallyExpanded: settings.initialTileExpanded,
              title: Text("クリックポイント"),
              children: [
                ...annotation.clickPoints.map((e) {
                  return ListTile(
                    leading: Text(e.id.toString()),
                    title: Text(
                        "[x: ${e.position.dx.toStringAsFixed(1)}, y: ${e.position.dy.toStringAsFixed(1)}]"),
                  );
                })
              ],
            ),
        ],
      ),
    );
  }
}
