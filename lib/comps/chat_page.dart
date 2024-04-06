// ignore_for_file: dead_code

import 'dart:developer';
import 'package:flutter_bing_client/comps/code_wrapper.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_wrap.dart';
import 'package:flutter_bing_client/src/rust/api/utils.dart';
import 'package:flutter_bing_client/types.dart';
import 'package:flutter_bing_client/util.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:get/get.dart';

bool isDark = false;

class ChatController extends GetxController {
  var messages = <types.Message>[].obs;
  var pendingMsgId = "";

  void setPendingMsgId(String id) {
    pendingMsgId = id;
    update();
  }

  void stopPending() {
    pendingMsgId = "";
    update();
  }

  bool checkPending() {
    return pendingMsgId.isNotEmpty;
  }

  void addMessage(types.Message message) {
    messages.insert(0, message);
    update();
  }

  void setMessages(List<types.Message> newMessages) {
    messages = newMessages.obs;
    update();
  }

  void modifyMessage(String id, types.Message newMessage) {
    int index = messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      messages[index] = newMessage;
      update();
    }
  }

  void removeMessage(String id) {
    messages.removeWhere((m) => m.id == id);
    update();
  }
}

class ChatPage extends StatefulWidget {
  final Stream<String> Function(List<types.Message>) onNewMessage;
  final Future Function(String id) onStop;
  final WrappedChat chat;
  final bool isNew;
  const ChatPage(
      {super.key,
      required this.chat,
      required this.onNewMessage,
      required this.onStop,
      required this.isNew});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController(), tag: widget.chat.conversationId);
    if (!widget.isNew) {
      fetchCharMsgs();
    }
  }

  void fetchCharMsgs() {
    getChatMsgs(id: widget.chat.conversationId).then((msgs) async {
      List<types.Message> newMessages = [];
      for (var index = msgs.length - 1; index >= 0; index--) {
        var msg = msgs[index];
        newMessages.add(types.TextMessage(
            author:
                msg.author == "user" ? globalUser : types.User(id: msg.author),
            text: msg.text,
            id: index.toString()));
      }
      controller.setMessages(newMessages);
      showSuccessSnackBar("刷新会话消息列表成功", context);
    }).catchError((e) async {
      log("Failed to get Chat Messages: $e");
      showErrorSnackBar("获取Chat Messages失败: $e", context);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.chat.chatName.split("\n")[0],
            overflow: TextOverflow.fade,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {
                fetchCharMsgs();
              },
            )
          ],
        ),
        body: GetBuilder<ChatController>(
          init: controller,
          builder: (controller) => Chat(
            theme: DefaultChatTheme(
              messageMaxWidth: MediaQuery.of(context).size.width * 0.8,
              primaryColor: Colors.black12,
            ),
            textMessageBuilder: _textMessageBuilder,
            messages: controller.messages,
            onMessageLongPress: _handleMessageLongPress,
            user: globalUser,
            customBottomWidget: CustomTextField(
              handleSend: (messages) {
                for (var msg in messages) {
                  controller.addMessage(msg);
                }
                _handleMessageStream(messages);
              },
              handleStop: () {
                widget.onStop(widget.chat.conversationId).then((_) {
                  showSuccessSnackBar("成功停止回答", context);
                  controller.stopPending();
                }).catchError((e) {
                  showErrorSnackBar("停止回答失败:$e", context);
                });
              },
              chatController: controller,
            ),
            onSendPressed: (_) {},
          ),
        ),
      );

  void _handleMessageStream(List<types.Message> messages) {
    controller.setPendingMsgId(generateUuidv4String());
    Stream<String> messageStream = widget.onNewMessage(messages);
    bool once = true;
    var handle = messageStream.listen((String data) {
      if (once) {
        controller.addMessage(types.TextMessage(
            author: const User(id: "bot"),
            text: data,
            id: controller.pendingMsgId));
        once = false;
      } else {
        controller.modifyMessage(
            controller.pendingMsgId,
            types.TextMessage(
                author: const User(id: "bot"),
                text: data,
                id: controller.pendingMsgId));
      }
    });
    handle.onDone(() {
      controller.stopPending();
    });
    handle.onError((e) {
      controller.stopPending();
      showErrorSnackBar("获取回答失败: $e", context);
    });
  }

  void _handleMessageLongPress(context, types.Message message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('复制'),
              onTap: () {
                String data;
                switch (message.type) {
                  case MessageType.text:
                    data = (message as types.TextMessage).text;
                    break;
                  default:
                    data = message.toJson()["uri"];
                }
                if (data.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: data));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _textMessageBuilder(types.TextMessage message,
      {required int messageWidth, required bool showName}) {
    bool isDark = false;
    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text, language) =>
        CodeWrapperWidget(child, text, language);
    Widget child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // 添加左右边距
      child: MarkdownBlock(
          data: message.text,
          config: config.copy(configs: [
            isDark
                ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
                : const PreConfig().copy(wrapper: codeWrapper)
          ])),
    );
    return child;
  }
}

class CustomTextField extends StatefulWidget {
  final Function(List<types.Message>) handleSend;
  final Function() handleStop;
  final ChatController chatController;
  const CustomTextField(
      {super.key,
      required this.handleSend,
      required this.handleStop,
      required this.chatController});

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();
  final List<types.Message> _storedMessages = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 100.0, // 最高高度
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              maxLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // 圆角矩形
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min, // 这一行是必要的，否则Row会占满整个宽度
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.fullscreen),
                      onPressed: () {
                        _showFullscreenDialog(context)
                            .then((value) => setState(() {
                                  _controller.text = value;
                                }));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            GestureDetector(
              onLongPress: () {
                setState(() {
                  _storedMessages.clear(); // 长按时清空所有的附件
                });
              },
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _handleAttachmentPressed,
              ),
            ),
            if (_storedMessages.isNotEmpty)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${_storedMessages.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
        if (widget.chatController.checkPending())
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: widget.handleStop,
          )
        else
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _handleSendPressed,
          )
      ],
    );
  }

  void _handleSendPressed() {
    if (_controller.text.isNotEmpty) {
      final textMessage = types.TextMessage(
        author: globalUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: generateUuidv4String(),
        text: _controller.text,
      );
      _storedMessages.add(textMessage);
    }
    if (_storedMessages.isNotEmpty) {
      widget.handleSend(_storedMessages);
      setState(() {
        _storedMessages.clear();
      });
    }
    setState(() {
      _controller.text = "";
    });
  }

  Future<String> _showFullscreenDialog(BuildContext context) async {
    double screenWidth = MediaQuery.of(context).size.width;
    CodeController controller = CodeController();
    controller.text = _controller.text;
    await showDialog(
      context: context,
      builder: (context) => ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.white), // 设置滚动条颜色为黑色
        ),
        child: Dialog(
          child: SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              child: CodeField(
                controller: controller,
                minLines: 10,
              ),
            ),
          ),
        ),
      ),
    );
    return controller.text;
  }

  void _handleAttachmentPressed() {
    void handleFileSelection() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final message = types.FileMessage(
          author: globalUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: generateUuidv4String(),
          name: result.files.single.name,
          size: result.files.single.size,
          uri: result.files.single.path!,
        );

        // 不立即添加消息，而是保存为一个状态
        setState(() {
          _storedMessages.add(message);
        });
      }
    }

    void handleImageSelection() async {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );

      if (result != null) {
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);

        final message = types.ImageMessage(
          author: globalUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: generateUuidv4String(),
          name: result.name,
          size: bytes.length,
          uri: result.path,
          width: image.width.toDouble(),
        );

        setState(() {
          _storedMessages.add(message);
        });
      }
    }

    showCupertinoModalBottomSheet(
        context: context,
        builder: (BuildContext context) => SafeArea(
              child: SizedBox(
                height: 200, // specify the height here
                child: Column(children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 20,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                  ),
                  const SizedBox(height: 18),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      handleImageSelection();
                    },
                    icon: const Icon(Icons.photo), // 添加图标
                    label: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Photo',
                          style: TextStyle(fontSize: 18)), // 调整字体大小
                    ),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16)), // 调整按钮高度
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      handleFileSelection();
                    },
                    icon: const Icon(Icons.attach_file), // 添加图标
                    label: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('File',
                          style: TextStyle(fontSize: 18)), // 调整字体大小
                    ),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16)), // 调整按钮高度
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel), // 添加图标
                    label: const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('Cancel',
                          style: TextStyle(fontSize: 18)), // 调整字体大小
                    ),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16)), // 调整按钮高度
                  ),
                ]),
              ),
            ));
  }
}

void navigate2ChatPage(WrappedChat chat, bool isNew, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ChatPage(
              chat: chat,
              onNewMessage: (List<types.Message> msgs) {
                var (text, imagePath) = processMsgs(msgs);
                return askStreamPlain(
                    chat: chat, textMsg: text, imagePath: imagePath);
              },
              onStop: (String id) async {
                return await stopAnswer(id: id);
              },
              isNew: isNew,
            )),
  );
}
