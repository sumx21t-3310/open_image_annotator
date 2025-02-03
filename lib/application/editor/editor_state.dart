import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_image_annotator/application/editor/project_notifier.dart';

class EditorState {
  int currentImageIndex = 0;
  int currentToolIndex = 0;
  bool enableBlur = true;

  EditorState copyWith({
    int? currentImageIndex,
    int? currentToolIndex,
    bool? enableBlur,
  }) {
    return EditorState()
      ..currentImageIndex = currentImageIndex ?? this.currentImageIndex
      ..currentToolIndex = currentToolIndex ?? this.currentToolIndex
      ..enableBlur = enableBlur ?? this.enableBlur;
  }
}

class EditorStateNotifier extends StateNotifier<EditorState> {
  EditorStateNotifier(super.state, this.ref);

  Ref ref;

  void changeImageAt(int index) {
    state = state.copyWith(currentImageIndex: index);
  }

  void nextImage() {
    final project = ref.watch(projectProvider);
    if (project == null) return;
    final length = project.annotations.length;
    final nextIndex = (state.currentImageIndex + 1) % length;
    changeImageAt(nextIndex);
  }

  void previousImage() {
    final project = ref.watch(projectProvider);
    if (project == null) return;
    final length = project.annotations.length;
    final prevIndex = (state.currentImageIndex - 1 + length) % length;
    changeImageAt(prevIndex);
  }

  void switchBlur(bool value) {
    state = state.copyWith(enableBlur: value);
  }

  void selectTool(int index) {
    state = state.copyWith(currentToolIndex: index);
  }
}

final editorStateProvider =
    StateNotifierProvider<EditorStateNotifier, EditorState>(
  (ref) => EditorStateNotifier(EditorState(), ref),
);
