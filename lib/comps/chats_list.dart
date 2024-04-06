import 'package:flutter/material.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';

class ConversationListView extends StatelessWidget {
  final List<WrappedChat> chats;
  final void Function(String title, String id) onEdit;
  final void Function(String id) onDelete;
  final void Function(WrappedChat chat) onItemClick;

  const ConversationListView({
    super.key,
    required this.chats,
    required this.onEdit,
    required this.onDelete,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(Colors.black),
      ),
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => onItemClick(chats[index]),
            title: Text(chats[index].chatName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: <Widget>[
                    Chip(
                      label: Text(chats[index].tone,
                          style: const TextStyle(fontSize: 15)),
                      padding: const EdgeInsets.all(0),
                    ),
                    ...chats[index].plugins.map((plugin) => Chip(
                          label: Text(plugin,
                              style: const TextStyle(fontSize: 15)),
                          padding: const EdgeInsets.all(0),
                        )),
                  ],
                ),
                Text(chats[index].updateTimeLocal),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final controller =
                        TextEditingController(text: chats[index].chatName);
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
                                onEdit(controller.text,
                                    chats[index].conversationId);
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
                  onPressed: () => onDelete(chats[index].conversationId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
