import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProgressData {
  final double current;
  final double total;
  final String? details;

  ProgressData({
    required this.current,
    required this.total,
    this.details,
  });
}

class ProgressDialog extends HookWidget {
  const ProgressDialog({
    super.key,
    required this.progressStream,
    this.onCancel,
    this.details,
    this.title,
  });

  final String? title;
  final ValueNotifier<String>? details;

  final Stream<ProgressData> progressStream;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: StreamBuilder(
        stream: progressStream,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) return CircularProgressIndicator();

          final progressData = snapshot.data!;
          double progress = progressData.total > 0.0
              ? progressData.current / progressData.total
              : 0.0;

          return Column(
            children: [
              LinearProgressIndicator(
                value: progress,
              ),
            ],
          );
        },
      ),
      actions: [
        if (onCancel != null)
          FilledButton(
            onPressed: () {
              onCancel!();
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          )
      ],
    );
  }
}
