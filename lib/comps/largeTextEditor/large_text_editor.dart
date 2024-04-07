import 'dart:ui';

import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bing_client/comps/largeTextEditor/find.dart';
import 'package:flutter_bing_client/comps/largeTextEditor/menu.dart';
import 'package:flutter_bing_client/util.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/csharp.dart';
import 'package:re_highlight/languages/css.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/languages/java.dart';
import 'package:re_highlight/languages/javascript.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/languages/python.dart';
import 'package:re_highlight/languages/sql.dart';

import 'package:re_highlight/languages/bash.dart';
import 'package:re_highlight/languages/c.dart';
import 'package:re_highlight/languages/cpp.dart';
import 'package:re_highlight/languages/objectivec.dart';
import 'package:re_highlight/languages/php.dart';
import 'package:re_highlight/languages/r.dart';
import 'package:re_highlight/languages/rust.dart';
import 'package:re_highlight/languages/swift.dart';
import 'package:re_highlight/languages/typescript.dart';
import 'package:re_highlight/styles/atom-one-dark-reasonable.dart';

class LargeTextEditor extends StatefulWidget {
  final CodeLineEditingController controller;
  const LargeTextEditor({super.key, required this.controller});

  @override
  State<StatefulWidget> createState() => _LargeTextEditorState();
}

class _LargeTextEditorState extends State<LargeTextEditor> {
  late final CodeLineEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return CodeEditor(
      style: CodeEditorStyle(
        codeTheme: CodeHighlightTheme(languages: {
          "json": CodeHighlightThemeMode(mode: langJson),
          "dart": CodeHighlightThemeMode(mode: langDart),
          'python': CodeHighlightThemeMode(mode: langPython),
          'javascript': CodeHighlightThemeMode(mode: langJavascript),
          'java': CodeHighlightThemeMode(mode: langJava),
          'css': CodeHighlightThemeMode(mode: langCss),
          'sql': CodeHighlightThemeMode(mode: langSql),
          'csharp': CodeHighlightThemeMode(mode: langCsharp),
          'c': CodeHighlightThemeMode(mode: langC),
          'cpp': CodeHighlightThemeMode(mode: langCpp),
          'typescript': CodeHighlightThemeMode(mode: langTypescript),
          'php': CodeHighlightThemeMode(mode: langPhp),
          'r': CodeHighlightThemeMode(mode: langR),
          'bash': CodeHighlightThemeMode(mode: langBash),
          'swift': CodeHighlightThemeMode(mode: langSwift),
          'objective-c': CodeHighlightThemeMode(mode: langObjectivec),
          "rust": CodeHighlightThemeMode(mode: langRust),
        }, theme: atomOneDarkReasonableTheme),
      ),
      controller: _controller,
      wordWrap: false,
      indicatorBuilder:
          (context, editingController, chunkController, notifier) {
        return Row(
          children: [
            DefaultCodeLineNumber(
              controller: editingController,
              notifier: notifier,
            ),
            DefaultCodeChunkIndicator(
                width: 20, controller: chunkController, notifier: notifier)
          ],
        );
      },
      findBuilder: (context, controller, readOnly) =>
          CodeFindPanelView(controller: controller, readOnly: readOnly),
      toolbarController: const ContextMenuControllerImpl(),
      sperator: Container(width: 1, color: Colors.blue),
    );
  }
}

Future<String?> navigateToLargeTextEditor(
    BuildContext context, String initText, bool confirm) {
  CodeLineEditingController controller = CodeLineEditingController();
  controller.text = initText;
  Future<String?> outText = Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (confirm) {
              showConfirmDialog(context, "确定舍弃所有新编辑的内容,只保留原本内容吗?")
                  .then((value) {
                if (value) {
                  Navigator.of(context).pop();
                }
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
          ),
        ],
      ),
      body: LargeTextEditor(controller: controller),
    ),
  ));
  return outText;
}
