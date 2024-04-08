import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bing_client/comps/Markdown/code_wrapper.dart';
import 'package:flutter_bing_client/comps/Markdown/custom_node.dart';
import 'package:flutter_bing_client/comps/Markdown/latex.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../platform_detector/platform_detector.dart';

class MarkdownPage extends StatefulWidget {
  final String? assetsPath;
  final String? markdownData;

  const MarkdownPage({super.key, this.assetsPath, this.markdownData})
      : assert(assetsPath != null || markdownData != null);

  @override
  MarkdownPageState createState() => MarkdownPageState();
}

class MarkdownPageState extends State<MarkdownPage> {
  ///key: [isEnglish] , value: data
  Map<bool, String> dataMap = {};
  String? data;
  bool isEnglish = true;
  final TocController controller = TocController();

  bool get isMobile => PlatformDetector.isAllMobile;

  @override
  void initState() {
    if (widget.assetsPath != null) {
      loadData(widget.assetsPath!);
    } else {
      data = widget.markdownData!;
    }
    super.initState();
  }

  void loadData(String assetsPath) {
    if (dataMap[isEnglish] != null) {
      data = dataMap[isEnglish]!;
      refresh();
      return;
    }
    rootBundle.loadString(assetsPath).then((data) {
      dataMap[isEnglish] = data;
      this.data = data;
      refresh();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : (isMobile ? buildMobileBody() : buildWebBody()),
      floatingActionButton: widget.assetsPath != null
          ? isMobile
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (ctx) => buildTocList());
                  },
                  heroTag: 'list',
                  child: const Icon(Icons.format_list_bulleted),
                )
              : const SizedBox()
          : null,
    );
  }

  Widget buildTocList() => TocWidget(controller: controller);

  Widget buildMarkdown() {
    final config = MarkdownConfig.defaultConfig;
    codeWrapper(child, text, language) =>
        CodeWrapperWidget(child, text, language);
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: MarkdownWidget(
        data: data!,
        config: config
            .copy(configs: [const PreConfig().copy(wrapper: codeWrapper)]),
        tocController: controller,
        markdownGenerator: MarkdownGenerator(
          generators: [latexGenerator],
          inlineSyntaxList: [LatexSyntax()],
          textGenerator: (node, config, visitor) =>
              CustomTextNode(node.textContent, config, visitor),
          richTextBuilder: (span) => Text.rich(span, textScaleFactor: 1),
        ),
      ),
    );
  }

  Widget buildCodeBlock(Widget child, String text, bool isEnglish) {
    return Stack(
      children: <Widget>[
        child,
        Container(
          margin: const EdgeInsets.only(top: 5, right: 5),
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Widget toastWidget = Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff006EDF), width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(
                        4,
                      )),
                      color: const Color(0xff007FFF)),
                  width: 150,
                  height: 40,
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        isEnglish ? 'Copy successful' : '复制成功',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
              ToastWidget().showToast(context, toastWidget, 500);
            },
            icon: const Icon(
              Icons.content_copy,
              size: 10,
            ),
          ),
        )
      ],
    );
  }

  Widget buildMobileBody() {
    return buildMarkdown();
  }

  Widget buildWebBody() {
    return Row(
      children: <Widget>[
        Expanded(child: buildTocList()),
        Expanded(
          flex: 3,
          child: buildMarkdown(),
        )
      ],
    );
  }
}

class ToastWidget {
  ToastWidget._internal();

  static ToastWidget? _instance;

  factory ToastWidget() {
    _instance ??= ToastWidget._internal();
    return _instance!;
  }

  bool isShowing = false;

  void showToast(BuildContext context, Widget widget, int milliseconds) {
    if (!isShowing) {
      isShowing = true;
      FullScreenDialog.getInstance().showDialog(
        context,
        widget,
      );
      Future.delayed(
          Duration(
            milliseconds: milliseconds,
          ), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          isShowing = false;
        } else {
          isShowing = false;
        }
      });
    }
  }
}

class FullScreenDialog {
  static FullScreenDialog? _instance;

  static FullScreenDialog getInstance() {
    _instance ??= FullScreenDialog._internal();
    return _instance!;
  }

  FullScreenDialog._internal();

  void showDialog(BuildContext context, Widget child) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (ctx, anm1, anm2) {
          return child;
        }));
  }
}
