import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bing_client/comps/Chat/chat_page.dart';
import 'package:flutter_bing_client/comps/Chat/chats_list.dart';
import 'package:flutter_bing_client/comps/Chat/new_chat.dart';
import 'package:flutter_bing_client/comps/settiing_page.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_wrap.dart';
import 'package:flutter_bing_client/src/rust/api/init.dart';
import 'package:flutter_bing_client/src/rust/frb_generated.dart';
import 'package:flutter_bing_client/util.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RustLib.init();
  try {
    await initLogger();
  } catch (_) {}
  await initRootPath(path: (await getApplicationCacheDirectory()).path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return MaterialApp(
      theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.black),
          ),
          textTheme: const TextTheme().useSystemChineseFont(brightness)),
      home: const HomeComp(),
    );
  }
}

class HomeComp extends StatefulWidget {
  const HomeComp({super.key});

  @override
  HomeCompState createState() => HomeCompState();
}

class HomeCompState extends State<HomeComp> {
  @override
  void initState() {
    super.initState();
    initializeCilentOnStart(context).then((_) {
      getUpdateChatList().then((value) {
        Get.find<ChatListController>().setChats(value);
      }).catchError((e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showErrorSnackBar("获取Chat List失败: $e" "\n可以尝试手动刷新.", context);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return MaterialApp(
      theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.black),
          ),
          textTheme: const TextTheme().useSystemChineseFont(brightness)),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'ChatList',
            style: const TextStyle(fontWeight: FontWeight.bold)
                .useSystemChineseFont(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.check_box_outline_blank),
              onPressed: () {
                Get.find<ChatListController>().toggleAllCheckbox();
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                navigate2SettingPage(context);
              },
            ),
          ],
        ),
        body: Center(
          child: ConversationListView(
            onEdit: (String title, String id) {
              renameChat(id: id, newName: title).then((_) {
                Get.find<ChatListController>().renameChat(id, title);
                if (mounted) {
                  showSuccessSnackBar("重命名Chat成功", context);
                }
              }).catchError((e) {
                if (mounted) {
                  showErrorSnackBar("重命名Chat失败: $e", context);
                }
              });
            },
            onDelete: (String id) {
              showConfirmDialog(context, "确认删除该chat吗?").then((value) {
                if (value) {
                  deleteChat(id: id).then((_) {
                    Get.find<ChatListController>().deleteChats([id]);
                    if (mounted) {
                      showSuccessSnackBar("删除Chat成功", context);
                    }
                    updateChatListWrapped(context);
                  }).catchError((e) {
                    if (mounted) {
                      showErrorSnackBar("删除Chat失败: $e", context);
                    }
                  });
                }
              });
            },
            onItemClick: (WrappedChat chat) {
              navigate2ChatPage(chat, false, context);
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "AddChat",
              child: const Icon(Icons.add),
              onPressed: () {
                createChat().then(
                  (newId) {
                    showAddChatDialog(newId, context).then((newChat) {
                      if (newChat != null) {
                        Get.find<ChatListController>().addChat(newChat);
                        navigate2ChatPage(newChat, true, context);
                      }
                    });
                  },
                ).catchError((e) {
                  showErrorSnackBar("创建新会话失败: $e", context);
                });
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            FloatingActionButton(
                heroTag: "RefreshChatList",
                child: const Icon(Icons.refresh),
                onPressed: () {
                  updateChatListWrapped(context);
                }),
            const Padding(padding: EdgeInsets.all(10)),
            FloatingActionButton(
              heroTag: "DeleteChatsTag",
              child: const Icon(Icons.delete_forever),
              onPressed: () {
                showConfirmDialog(context, "确认删除选中的chat吗?").then((value) {
                  if (value) {
                    var ids = Get.find<ChatListController>().getSelectedIds();
                    deleteChats(
                      ids: ids,
                    ).then((_) {
                      Get.find<ChatListController>().deleteChats(ids);
                      if (mounted) {
                        showSuccessSnackBar("删除选中chats成功", context);
                      }
                      updateChatListWrapped(context);
                    }).catchError((e) {
                      if (mounted) {
                        showErrorSnackBar("删除选中chats失败: $e", context);
                      }
                    });
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void updateChatListWrapped(BuildContext context) {
  getUpdateChatList().then((value) {
    Get.find<ChatListController>().setChats(value);

    if (context.mounted) {
      showSuccessSnackBar("刷新Chat List成功", context);
    }
  }).catchError((e) {
    if (context.mounted) {
      showErrorSnackBar("刷新Chat List失败: $e", context);
    }
  });
}
