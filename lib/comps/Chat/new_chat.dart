import 'package:flutter/material.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

Future<WrappedChat?> showAddChatDialog(
  String newId,
  BuildContext context,
) async {
  final formKey = GlobalKey<FormState>();
  final tones = ['Creative', 'Balanced', 'Precise'];
  final plugins = ['Search', 'Instacart', 'Kayak', 'OpenTable', 'Shop', 'Suno'];
  String selectedTone = tones[0];
  List<String> selectedPlugins = [];

  return showDialog<WrappedChat?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Chat',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200.0), // 你可以根据需要调整这个值
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    value: selectedTone,
                    items: tones.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style:
                                const TextStyle(fontWeight: FontWeight.normal)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedTone = newValue!;
                    },
                    decoration: const InputDecoration(labelText: 'Tone'),
                  ),
                  MultiSelectDialogField(
                    dialogWidth: 100,
                    dialogHeight: 300,
                    items: plugins
                        .map(
                            (plugin) => MultiSelectItem<String>(plugin, plugin))
                        .toList(),
                    title: const Text("Plugins",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onConfirm: (values) {
                      selectedPlugins = values;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Submit',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(
                  WrappedChat(
                    conversationId: newId,
                    chatName: "New Chat".obs,
                    tone: selectedTone,
                    updateTimeLocal: DateTime.now().toIso8601String(),
                    plugins: selectedPlugins,
                  ),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
