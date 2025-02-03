import 'package:open_image_annotator/presentation/common/responsive_layout.dart';
import 'package:open_image_annotator/presentation/editor/editor_body.dart';
import 'package:open_image_annotator/presentation/editor/hierarchy.dart';
import 'package:open_image_annotator/presentation/editor/inspector.dart';
import 'package:flutter/material.dart';

import 'editor_appbar.dart';
import 'toolbar.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final body = EditorBody();
    final inspector = Inspector();
    final hierarchy = Hierarchy();
    final toolbar = Toolbar();
    final appBar = EditorAppBar();

    return ResponsiveLayout(
      layouts: {
        0: Scaffold(
          appBar: appBar,
          endDrawer: Drawer(
            shape: ContinuousRectangleBorder(),
            child: Column(
              children: [
                Expanded(child: inspector),
                Expanded(child: hierarchy),
              ],
            ),
          ),
          body: Row(children: [toolbar, Expanded(child: body)]),
        ),
        1100: Scaffold(
          appBar: appBar,
          body: Row(
            children: [
              toolbar,
              Expanded(
                flex: 8,
                child: body,
              ),
              Card(
                shape: ContinuousRectangleBorder(),
                margin: EdgeInsets.zero,
                elevation: 5,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: inspector,
                      ),
                      Expanded(
                        child: hierarchy,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      },
    );
  }
}
