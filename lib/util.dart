import 'dart:io';

import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_wrap.dart';
import 'package:flutter_bing_client/src/rust/api/utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_bing_client/comps/Cookie/desktop_webview_cookie.dart'
    as desktop_cookie;
import 'package:flutter_bing_client/comps/Cookie/mobile_webview_cookie.dart'
    as mobile_cookie;

final talker = TalkerFlutter.init();

void showErrorSnackBar(String message, BuildContext context) {
  talker.error(message);
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
    ),
  );
}

void showInfoSnackBar(String message, BuildContext context) {
  talker.info(message);
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(
      message: message,
    ),
  );
}

void showSuccessSnackBar(String message, BuildContext context) {
  talker.info("Success: $message");
  showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
      ),
      displayDuration: const Duration(microseconds: 500),
      animationDuration: const Duration(seconds: 1));
}

(String, String?) processMsgs(List<Message> msgs, BuildContext context) {
  String? imagePath;
  String text = "";
  if (msgs.isEmpty) {
    return ("", null);
  }
  for (var msg in msgs) {
    if (msg.type == MessageType.file) {
      try {
        String name = (msg as FileMessage).name;
        String value = readFile(
          path: msg.uri,
        );
        text += "FileName: $name\nFileContent: $value";
      } catch (e) {
        if (context.mounted) {
          showErrorSnackBar("加载附件失败:$e", context);
        }
      }
    }
    if (msg.type == MessageType.image) {
      imagePath = (msg as ImageMessage).uri;
    }
    if (msg.type == MessageType.text) {
      text += (msg as TextMessage).text;
    }
  }
  return (text, imagePath);
}

Future<void> initializeCilentOnStart(BuildContext context) async {
  try {
    await tryLoadClient();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      talker.info("加载BingClient成功");
    });
  } catch (e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInfoSnackBar("请先登录微软账号", context);
    });
    String cookie = "";
    if (Platform.isAndroid || Platform.isIOS) {
      if (context.mounted) {
        cookie = await mobile_cookie.getCookie(context);
      }
    } else {
      cookie = await desktop_cookie.getCookie();
    }
    try {
      await recreateClientSave(cookieStr: cookie);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSuccessSnackBar("创建BingClient成功", context);
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorSnackBar("创建BingClient失败: $e", context);
      });
    }
  }
}

Future<void> fetchCookieRecreateClient(BuildContext context) async {
  String cookie = "";
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showInfoSnackBar("请登录微软账号,并等待自动返回", context);
  });
  if (Platform.isAndroid || Platform.isIOS) {
    cookie = await mobile_cookie.getCookie(context);
  } else {
    cookie = await desktop_cookie.getCookie();
  }
  try {
    await recreateClientSave(cookieStr: cookie);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSuccessSnackBar("创建BingClient成功", context);
    });
  } catch (e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showErrorSnackBar("创建BingClient失败: $e", context);
    });
  }
}

Future<void> tryLoadClientWrapped(BuildContext context) async {
  tryLoadClient().then((_) {
    showSuccessSnackBar("成功加载BingClient", context);
  }).catchError((e) {
    showErrorSnackBar("加载BingClient失败: $e", context);
  });
}

bool isAllowType(String mimetype) {
  if (mimetype.startsWith("text")) {
    return true;
  }
  var allowList = ["json", "x-sh", "html", "xml", "toml", "yml", "yaml"];
  for (var allow in allowList) {
    if (mimetype.contains(allow)) {
      return true;
    }
  }
  return false;
}

Future<bool> showConfirmDialog(BuildContext context, String prompt) async {
  bool? result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '确认',
          style: const TextStyle(fontWeight: FontWeight.bold)
              .useSystemChineseFont(),
        ),
        content: Text(
          prompt,
          style: const TextStyle(fontWeight: FontWeight.normal)
              .useSystemChineseFont(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              '取消',
              style: const TextStyle(fontWeight: FontWeight.bold)
                  .useSystemChineseFont(),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(
              '确定',
              style: const TextStyle(fontWeight: FontWeight.bold)
                  .useSystemChineseFont(),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  return result ?? false;
}
