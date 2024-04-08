import 'package:flutter/material.dart';
import 'package:flutter_bing_client/comps/Markdown/code_wrapper.dart';
import 'package:flutter_bing_client/comps/Markdown/custom_node.dart';
import 'package:flutter_bing_client/comps/Markdown/latex.dart';
import 'package:flutter_bing_client/comps/Markdown/markdown_page.dart';
import 'package:flutter_bing_client/comps/platform_detector/platform_detector.dart';
import 'package:flutter_bing_client/util.dart';
import 'package:markdown_widget/markdown_widget.dart';

class EditMarkDownWrappedPage extends StatefulWidget {
  final String initialData;
  final bool saveAble;
  final bool confirm;
  const EditMarkDownWrappedPage(
      {super.key,
      required this.initialData,
      this.confirm = false,
      this.saveAble = false});

  @override
  EditMarkDownWrappedPageState createState() => EditMarkDownWrappedPageState();
}

class EditMarkDownWrappedPageState extends State<EditMarkDownWrappedPage> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (widget.confirm) {
          final shouldPop =
              await showConfirmDialog(context, "确定要返回而不保存本次编辑后变化的内容吗?");
          return shouldPop;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (widget.confirm) {
                  showConfirmDialog(context, "确定要返回而不保存本次编辑后变化的内容吗?")
                      .then((value) {
                    if (value) {
                      Navigator.pop(context, null);
                    }
                  });
                } else {
                  Navigator.pop(context, null);
                }
              }),
          actions: [
            if (widget.saveAble)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => Navigator.pop(context, controller.text),
              ),
          ],
        ),
        body: EditMarkdownPage(
          controller: controller,
        ),
      ),
    );
  }
}

class EditMarkdownPage extends StatefulWidget {
  final TextEditingController controller;
  const EditMarkdownPage({super.key, required this.controller});

  @override
  EditMarkdownPageState createState() => EditMarkdownPageState();
}

class EditMarkdownPageState extends State<EditMarkdownPage> {
  bool isMobileDisplaying = false;

  bool get isMobile => PlatformDetector.isAllMobile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildDisplay(),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () {
                isMobileDisplaying = !isMobileDisplaying;
                refresh();
              },
              child: Icon(
                isMobileDisplaying
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye,
              ),
            )
          : null,
    );
  }

  Widget buildDisplay() {
    if (isMobileDisplaying) {
      return MarkdownPage(markdownData: widget.controller.text);
    }
    return buildEditor();
  }

  Widget buildEditor() => isMobile ? buildMobileBody() : buildWebBody();

  Widget buildMobileBody() {
    return buildEditText();
  }

  Widget buildWebBody() {
    return Row(
      children: <Widget>[
        Expanded(child: buildEditText()),
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: MarkdownWidget(
            data: widget.controller.text,
            config: MarkdownConfig.defaultConfig.copy(configs: [
              const PreConfig().copy(
                  wrapper: (child, text, language) =>
                      CodeWrapperWidget(child, text, language))
            ]),
            markdownGenerator: MarkdownGenerator(
              generators: [latexGenerator],
              inlineSyntaxList: [LatexSyntax()],
              textGenerator: (node, config, visitor) =>
                  CustomTextNode(node.textContent, config, visitor),
              richTextBuilder: (span) =>
                  Text.rich(span, textScaler: const TextScaler.linear(1)),
            ),
          ),
        )),
      ],
    );
  }

  Widget buildEditText() {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: TextFormField(
        expands: true,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        controller: widget.controller,
        onChanged: (text) {
          refresh();
        },
        style: const TextStyle(textBaseline: TextBaseline.alphabetic),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            hintText: 'Input Here...',
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}

Future<String?> navigateToEditMarkdownPage(
    BuildContext context, String text, bool saveAble, bool confirm) async {
  String? modifiedText = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditMarkDownWrappedPage(
        initialData: text,
        saveAble: saveAble,
        confirm: confirm,
      ),
    ),
  );
  return modifiedText;
}
