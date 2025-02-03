import 'package:open_image_annotator/application/editor/editor_state.dart';
import 'package:open_image_annotator/application/editor/project_notifier.dart';
import 'package:open_image_annotator/domain/dataset/annotation.dart';
import 'package:open_image_annotator/presentation/common/tap_shield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';

class Hierarchy extends ConsumerWidget {
  const Hierarchy({
    super.key,
  });

  List<Widget> generateLayerList(List<Annotation>? annotations, WidgetRef ref) {
    if (annotations == null) return [];
    return List<Widget>.generate(annotations.length, (index) {
      final annotationData = annotations[index];
      final selected =
          index == ref.watch(editorStateProvider).currentImageIndex;
      return AnnotationTile(
        annotationData: annotationData,
        selected: selected,
        onSelection: () =>
            ref.read(editorStateProvider.notifier).changeImageAt(index),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectNotifier = ref.read(projectProvider.notifier);
    final editorState = ref.watch(editorStateProvider);
    final project = ref.watch(projectProvider);

    final annotations = project?.annotations;
    return TapShield(
      allowTap: project != null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Tooltip(
                    message: "画像を追加",
                    child: IconButton(
                      onPressed: projectNotifier.pickImage,
                      icon: Icon(FontAwesomeIcons.images),
                    ),
                  ),
                  Tooltip(
                    message: "フォルダ単位で画像を追加",
                    child: IconButton(
                      onPressed: projectNotifier.pickFolder,
                      icon: Icon(FontAwesomeIcons.folderPlus),
                    ),
                  ),
                  Tooltip(
                    message: "選択中の画像を削除",
                    child: IconButton(
                      onPressed: () => projectNotifier
                          .deleteImage(editorState.currentImageIndex),
                      icon: Icon(FontAwesomeIcons.trash),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black12,
              child: ListView(children: generateLayerList(annotations, ref)),
            ),
          ),
        ],
      ),
    );
  }
}

class AnnotationTile extends StatelessWidget {
  const AnnotationTile({
    super.key,
    required this.annotationData,
    required this.selected,
    required this.onSelection,
  });

  final Annotation annotationData;
  final bool selected;
  final VoidCallback onSelection;

  List<Widget> buildAnnotationList() {
    final saliencyPoint = annotationData.clickPoints.map((point) {
      final x = point.position.dx.toStringAsFixed(2);
      final y = point.position.dy.toStringAsFixed(2);

      return ListTile(
        title: Text("[$x, $y]"),
      );
    }).toList();
    return [
      if (saliencyPoint.isNotEmpty)
        ExpansionTile(
          title: Text("Bubble View"),
          children: saliencyPoint,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme;

    return ListTile(
      selected: selected,
      selectedColor: colorScheme.primary,
      selectedTileColor: colorScheme.primaryContainer,
      onTap: onSelection,
      leading: Text(annotationData.id.toString()),
      title: Text(
        basename(annotationData.image.path),
        style: style.labelMedium?.copyWith(
          color: selected ? colorScheme.primary : null,
        ),
      ),
    );
  }
}
