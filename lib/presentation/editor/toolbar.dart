import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tools = <Icon>[];

class Toolbar extends HookConsumerWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = useState(0);

    return Material(
      elevation: 5,
      child: SizedBox(
        width: 40,
        child: Column(
          children: tools,
        ),
      ),
    );
  }
}
