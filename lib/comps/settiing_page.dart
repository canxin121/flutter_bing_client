import 'package:flutter/material.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_types.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_wrap.dart';
import 'package:flutter_bing_client/util.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  DisplayConfig config = const DisplayConfig(
    state: false,
    rootPath: 'loading',
    cookie: 'loading',
    chatListLen: 0,
    stopSignalLen: 0,
  );

  @override
  void initState() {
    super.initState();
    fetchDisplayConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            leading: Icon(Icons.check_circle,
                color: config.state ? Colors.green : Colors.red),
            title: Text('客户端状态信息: ${config.state ? '正常' : '异常'}'),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                fetchDisplayConfig();
              },
            ),
            initiallyExpanded:
                true, // Add this line to ensure the tile is initially expanded
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.folder),
                title: Text('Root Path: ${config.rootPath}'),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: Text('Chat List Length: ${config.chatListLen}'),
              ),
              ListTile(
                leading: const Icon(Icons.signal_cellular_alt),
                title: Text('Stop Signal Length: ${config.stopSignalLen}'),
              ),
              ListTile(
                leading: const Icon(Icons.cookie),
                title: Text('Cookie: ${config.cookie}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialogGetCookie(context, config.cookie)
                        .then((cookieOption) {
                      if (cookieOption != null) {
                        recreateClientSave(cookieStr: cookieOption).then((_) {
                          fetchCookieRecreateClient(context);
                        }).catchError((e) {
                          showErrorSnackBar("创建BingClient失败: $e", context);
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('重新加载客户端'),
            onTap: () {
              tryLoadClientWrapped(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('获取Cookie重建客户端'),
            onTap: () {
              fetchCookieRecreateClient(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('日志'),
            onTap: () {
              navigate2TalkerLogPage(context);
            },
          ),
        ],
      ),
    );
  }

  void fetchDisplayConfig() {
    displayGlobalState().then((config_) {
      setState(() {
        config = config_;
      });
    }).catchError((e) {
      showErrorSnackBar("获取状态信息失败", context);
    });
  }
}

void navigate2TalkerLogPage(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => TalkerScreen(talker: talker),
  ));
}

void navigate2SettingPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SettingPage()),
  );
}

Future<String?> showDialogGetCookie(
    BuildContext context, String currentCookie) async {
  String? newCookie = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController cookieController =
          TextEditingController(text: currentCookie);

      return AlertDialog(
        title: const Text('修改 Cookie'),
        content: TextField(
          controller: cookieController,
          autofocus: true,
          decoration: const InputDecoration(hintText: '请输入新的 Cookie 值'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('确认'),
            onPressed: () {
              Navigator.of(context).pop(cookieController.text);
            },
          ),
        ],
      );
    },
  );

  return newCookie;
}
