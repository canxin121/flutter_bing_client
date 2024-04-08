import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bing_client/comps/Markdown/code_wrapper.dart';
import 'package:flutter_bing_client/comps/Markdown/custom_node.dart';
import 'package:flutter_bing_client/comps/Markdown/latex.dart';
import 'package:flutter_bing_client/comps/Markdown/markdown_page.dart';
import 'package:flutter_bing_client/comps/platform_detector/platform_detector.dart';
import 'package:markdown_widget/markdown_widget.dart';

class EditMarkDownWrappedPage extends StatefulWidget {
  final String initialData;

  const EditMarkDownWrappedPage({super.key, this.initialData = ''});

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, controller.text),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, controller.text),
          ),
        ],
      ),
      body: EditMarkdownPage(initialData: widget.initialData),
    );
  }
}

class EditMarkdownPage extends StatefulWidget {
  final String initialData;

  const EditMarkdownPage({super.key, this.initialData = ''});

  @override
  EditMarkdownPageState createState() => EditMarkdownPageState();
}

class EditMarkdownPageState extends State<EditMarkdownPage> {
  late TextEditingController controller;
  bool isMobileDisplaying = false;

  bool get isMobile => PlatformDetector.isAllMobile;

  @override
  void initState() {
    final text = widget.initialData;
    controller = TextEditingController(text: text);
    if (text.isEmpty) {
      rootBundle.loadString('assets/editor.md').then((value) {
        controller.text = value;
        refresh();
      });
    }
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
    if (isMobileDisplaying) return MarkdownPage(markdownData: controller.text);
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
          child: MarkdownWidget(
            data: controller.text,
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
              richTextBuilder: (span) => Text.rich(span, textScaleFactor: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEditText() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: TextFormField(
        expands: true,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        controller: controller,
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
    controller.dispose();
  }
}

Future<String> navigateToEditMarkdownPage(
    BuildContext context, String text) async {
  String modifiedText = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditMarkDownWrappedPage(initialData: text),
    ),
  );
  return modifiedText;
}
