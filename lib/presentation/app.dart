import 'package:open_image_annotator/application/settings/settings_state.dart';
import 'package:open_image_annotator/presentation/routing.dart';
import 'package:open_image_annotator/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnotationApp extends ConsumerWidget {
  const AnnotationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'open image annotator',
      theme: Brightness.light.theme(context),
      darkTheme: Brightness.dark.theme(context),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
    );
  }
}
