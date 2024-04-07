//import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bing_client/comps/chat_page.dart';
import 'package:flutter_bing_client/comps/chats_list.dart';
import 'package:flutter_bing_client/comps/new_chat.dart';
import 'package:flutter_bing_client/comps/settiing_page.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_wrap.dart';
import 'package:flutter_bing_client/src/rust/api/init.dart';
import 'package:flutter_bing_client/src/rust/frb_generated.dart';
import 'package:flutter_bing_client/util.dart';
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
    return MaterialApp(
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
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
  List<WrappedChat> chats = [];

  @override
  void didChangeDependencies() async {
    await initializeCilentOnStart(context).then((_) {
      talker.info("尝试获取chatlist");
      getUpdateChatList().then((value) {
        setState(() {
          chats = value;
        });
      }).catchError((e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // ignore: use_build_context_synchronously
          showErrorSnackBar("获取Chat List失败: $e" "\n可以尝试手动刷新.", context);
        });
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ChatList'),
          actions: <Widget>[
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
            chats: chats,
            onEdit: (String title, String id) {
              renameChat(id: id, newName: title).then((_) {
                setState(() {
                  chats
                      .firstWhere((chat) => chat.conversationId == id)
                      .chatName = title;
                });
                if (context.mounted) {
                  // ignore: use_build_context_synchronously
                  showSuccessSnackBar("重命名Chat成功", context);
                }
              }).catchError((e) {
                if (context.mounted) {
                  // ignore: use_build_context_synchronously
                  showErrorSnackBar("重命名Chat失败: $e", context);
                }
              });
            },
            onDelete: (String id) {
              deleteChat(id: id).then((_) {
                setState(() {
                  chats.removeWhere((chat) => chat.conversationId == id);
                });
                if (context.mounted) {
                  // ignore: use_build_context_synchronously
                  showSuccessSnackBar("删除Chat成功", context);
                }
              }).catchError((e) {
                if (context.mounted) {
                  // ignore: use_build_context_synchronously
                  showErrorSnackBar("删除Chat失败: $e", context);
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
                        setState(() {
                          chats.insert(0, newChat);
                          navigate2ChatPage(newChat, true, context);
                        });
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
                getUpdateChatList().then((value) {
                  setState(() {
                    chats = value;
                  });
                  if (context.mounted) {
                    // ignore: use_build_context_synchronously
                    showSuccessSnackBar("刷新Chat List成功", context);
                  }
                }).catchError((e) {
                  if (context.mounted) {
                    // ignore: use_build_context_synchronously
                    showErrorSnackBar("刷新Chat List失败: $e", context);
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
