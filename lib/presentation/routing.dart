import 'package:open_image_annotator/presentation/editor/editor_page.dart';
import 'package:go_router/go_router.dart';

import 'settings/settings_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => EditorPage()),
    GoRoute(path: "/settings", builder: (context, state) => SettingsPage()),
  ],
);
