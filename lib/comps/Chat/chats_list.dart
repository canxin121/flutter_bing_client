import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';
import 'package:get/get.dart';

var currentAllState = false;

class ChatListController extends GetxController {
  RxList<WrappedChat> chats = <WrappedChat>[].obs;
  var checkboxSelected = {}.obs;

  void setChats(List<WrappedChat> chats_) {
    chats.assignAll(chats_);
    for (var chat in chats) {
      checkboxSelected[chat.conversationId] = false;
    }
    update();
  }

  void addChat(WrappedChat newChat) {
    chats.insert(0, newChat);
    update();
  }

  void deleteChats(List<String> ids) {
    for (var id in ids) {
      chats.removeWhere((chat) => chat.conversationId == id);
    }
    update();
  }

  void renameChat(String id, String newName) {
    final chat = chats.firstWhere((chat) => chat.conversationId == id);
    chat.chatName.value = newName;
    update();
  }

  void toggleCheckbox(String id) {
    checkboxSelected[id] = !(checkboxSelected[id] ?? false);
    update();
  }

  void toggleAllCheckbox() {
    currentAllState = !currentAllState;
    checkboxSelected.keys.toList().forEach((id) {
      checkboxSelected[id] = currentAllState;
    });
    update();
  }

  List<String> getSelectedIds() {
    return checkboxSelected.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key.toString())
        .toList();
  }
}

class ConversationListView extends StatefulWidget {
  final void Function(String title, String id) onEdit;
  final void Function(String id) onDelete;
  final void Function(WrappedChat chat) onItemClick;

  const ConversationListView({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onItemClick,
  });

  @override
  ConversationListViewState createState() => ConversationListViewState();
}

class ConversationListViewState extends State<ConversationListView> {
  final ChatListController _chatlistcontroller = Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.black),
        ),
        child: Obx(
          () => ListView.builder(
            itemCount: _chatlistcontroller.chats.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () =>
                    widget.onItemClick(_chatlistcontroller.chats[index]),
                title: Obx(() => Text(
                    _chatlistcontroller.chats[index].chatName.value,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
                leading: Obx(() => Checkbox(
                      value: _chatlistcontroller.checkboxSelected[
                              _chatlistcontroller
                                  .chats[index].conversationId] ??
                          false,
                      onChanged: (bool? value) {
                        _chatlistcontroller.toggleCheckbox(
                            _chatlistcontroller.chats[index].conversationId);
                      },
                    )),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8.0, // gap between adjacent chips
                      runSpacing: 4.0, // gap between lines
                      children: <Widget>[
                        Chip(
                          label: Text(_chatlistcontroller.chats[index].tone,
                              style: const TextStyle(fontSize: 15)
                                  .useSystemChineseFont()),
                          padding: const EdgeInsets.all(0),
                        ),
                        ..._chatlistcontroller.chats[index].plugins
                            .map((plugin) => Chip(
                                  label: Text(plugin,
                                      style: const TextStyle(fontSize: 15)
                                          .useSystemChineseFont()),
                                  padding: const EdgeInsets.all(0),
                                )),
                      ],
                    ),
                    Text(_chatlistcontroller.chats[index].updateTimeLocal,
                        style: const TextStyle(fontWeight: FontWeight.w200)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        final controller = TextEditingController(
                            text: _chatlistcontroller
                                .chats[index].chatName.value);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Edit Chat Name'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                    hintText: "Enter new chat name"),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('CANCEL'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    widget.onEdit(
                                        controller.text,
                                        _chatlistcontroller
                                            .chats[index].conversationId);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => widget.onDelete(
                          _chatlistcontroller.chats[index].conversationId),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
