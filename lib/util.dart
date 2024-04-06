import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bing_client/src/rust/api/bing_client_wrap.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_bing_client/comps/desktop_webview_cookie.dart'
    as desktop_cookie;
import 'package:flutter_bing_client/comps/mobile_webview_cookie.dart'
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

(String, String?) processMsgs(List<Message> msgs) {
  String? imagePath;
  String? text;
  for (var msg in msgs) {
    if (msg.type == MessageType.image) {
      imagePath = (msg as ImageMessage).uri;
    }
    if (msg.type == MessageType.text) {
      text = (msg as TextMessage).text;
    }
  }
  if (text == null && imagePath != null) {
    text = "";
  }
  return (text!, imagePath);
}

Future<void> initializeCilentOnStart(BuildContext context) async {
  try {
    await tryLoadClient();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: use_build_context_synchronously
      showSuccessSnackBar("加载BingClient成功", context);
    });
  } catch (e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showInfoSnackBar("请先登录微软账号", context);
    });
    String cookie = "";
    if (Platform.isAndroid || Platform.isIOS) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        cookie = await mobile_cookie.getCookie(context);
      }
    } else {
      cookie = await desktop_cookie.getCookie();
    }
    try {
      await recreateClientSave(cookieStr: cookie);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ignore: use_build_context_synchronously
        showSuccessSnackBar("创建BingClient成功", context);
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ignore: use_build_context_synchronously
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
    if (context.mounted) {
      // ignore: use_build_context_synchronously
      cookie = await mobile_cookie.getCookie(context);
    }
  } else {
    cookie = await desktop_cookie.getCookie();
  }
  try {
    await recreateClientSave(cookieStr: cookie);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: use_build_context_synchronously
      showSuccessSnackBar("创建BingClient成功", context);
    });
  } catch (e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: use_build_context_synchronously
      showErrorSnackBar("创建BingClient失败: $e", context);
    });
  }
}

Future<void> tryLoadClientWrapped(BuildContext context) async {
  tryLoadClient().then((_) {
    showSuccessSnackBar("成功加载BingClient", context);
  }).catchError((e) {
    showErrorSnackBar("加载BingClient失败: &e", context);
  });
}
