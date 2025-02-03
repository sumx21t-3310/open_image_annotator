import 'package:open_image_annotator/application/editor/project_notifier.dart';
import 'package:open_image_annotator/domain/dataset/dataset.dart';
import 'package:open_image_annotator/domain/dataset/label.dart';
import 'package:open_image_annotator/domain/dataset/metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectNameEditingDialog extends ConsumerWidget {
  const ProjectNameEditingDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: ref.watch(projectProvider)?.metaData.projectName,
    );

    return AlertDialog(
      title: Text("プロジェクト名を編集する"),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("キャンセル"),
        ),
        FilledButton(
          onPressed: () {
            ref
                .read(projectProvider.notifier)
                .changeProjectName(controller.text);
            Navigator.of(context).pop();
          },
          child: const Text("変更"),
        ),
      ],
    );
  }
}

class ProjectOverwriteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ProjectOverwriteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("新しいプロジェクトを作成しますか？"),
      content: const Text("現在のプロジェクトは破棄されます。この操作を続行してもよろしいですか？"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          child: const Text("続行"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("キャンセル"),
        ),
      ],
    );
  }
}

class ProjectCreateDialogResult {
  final String projectName;
  final String author;
  final String licence;
  final List<String> labels;

  ProjectCreateDialogResult(
      {required this.author,
      required this.licence,
      required this.projectName,
      required this.labels});
}

class ProjectCreateDialog extends HookWidget {
  final ValueChanged<Dataset> onCreate;

  const ProjectCreateDialog({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final labels = useState<List<String>>([]);
    final nameController = useTextEditingController(text: "名称未設定のプロジェクト");
    final labelController = useTextEditingController();
    final authorController = useTextEditingController();
    final licenceController = useTextEditingController(text: "MIT");

    final style = Theme.of(context).textTheme;

    return Dialog(
      child: SizedBox(
        width: 900,
        height: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 32,
          ),
          child: Column(
            spacing: 20,
            children: [
              Text(
                "新しいプロジェクト",
                style: style.headlineSmall,
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("プロジェクト名"),
                        ),
                        subtitle: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "My New Project",
                            suffixIcon: IconButton(
                              onPressed: () => nameController.text = "",
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("作者"),
                        subtitle: TextField(
                          controller: authorController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Your name",
                            suffixIcon: IconButton(
                              onPressed: () => authorController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("ライセンス"),
                        subtitle: TextField(
                          controller: licenceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "(例) MIT",
                            suffixIcon: IconButton(
                              onPressed: () => licenceController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("ラベルを追加"),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: labelController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "(例) monkey",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (labelController.text.isEmpty) return;

                                      labels.value = [
                                        ...labels.value,
                                        labelController.text
                                      ];

                                      labelController.clear();
                                    },
                                    icon: Icon(Icons.new_label),
                                  ),
                                ),
                              ),
                            ),
                            ...labels.value.asMap().entries.map(
                                  (e) => ListTile(
                                    leading: CircleAvatar(),
                                    title: Text(e.value),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            final values = labels.value;
                                            values.removeAt(e.key);
                                            labels.value = [...values];
                                          },
                                          icon: Icon(Icons.delete),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    child: const Text("キャンセル"),
                  ),
                  FilledButton(
                    onPressed: () {
                      final metadata = Metadata.fromLabelsList(
                        labels.value,
                        projectName: nameController.text,
                        author: authorController.text,
                        license: licenceController.text.isEmpty
                            ? "proprietary"
                            : licenceController.text,
                      );

                      final result = Dataset(
                        metaData: metadata,
                        projectLabels: labels.value
                            .asMap()
                            .entries
                            .map((e) => Label(id: e.key, name: e.value))
                            .toList(),
                      );

                      Navigator.of(context).pop(result);
                      onCreate(result);
                    },
                    child: const Text("作成"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Dataset?> showProjectCreateDialog(BuildContext context) async {
  return await showDialog<Dataset>(
    context: context,
    builder: (context) => ProjectCreateDialog(
      onCreate: (_) {},
    ),
  );
}

Future<void> createNewProject(BuildContext context, WidgetRef ref) async {
  final currentProject = ref.watch(projectProvider);
  if (currentProject != null) {
    final agreeToCreateNew = await showDialog<bool?>(
      context: context,
      builder: (context) => ProjectOverwriteDialog(
        onConfirm: () {},
      ),
    );

    if (agreeToCreateNew == false || agreeToCreateNew == null) return;
  }

  // プロジェクト名入力ダイアログ
  final result = await showProjectCreateDialog(context);

  // ユーザーがキャンセルした場合
  if (result == null || result.metaData.projectName.isEmpty) return;

  // プロジェクトの作成処理を実行
  ref.read(projectProvider.notifier).createProject(result);
}
