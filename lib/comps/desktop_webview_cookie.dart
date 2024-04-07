import 'dart:async';
import 'dart:developer';
// import 'dart:developer';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> getCookie() async {
  String url = "https://login.live.com/";
  Webview? currentWebview;
  final cookieCompleter = Completer<String>();
  bool webviewAvailable = false;
  try {
    webviewAvailable = await WebviewWindow.isWebviewAvailable();
  } catch (e) {
    log("Failed on webviewAvailable: $e");
    webviewAvailable = false;
  }
  if (webviewAvailable) {
    await WebviewWindow.clearAll(
        userDataFolderWindows: await _getWebViewPath());
    currentWebview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        userDataFolderWindows: await _getWebViewPath(),
        titleBarTopPadding: Platform.isMacOS ? 20 : 0,
      ),
    );
    currentWebview
      ..setBrightness(Brightness.dark)
      ..launch(url)
      ..addOnUrlRequestCallback((url) async {
        if (url.startsWith("https://account.microsoft.com")) {
          currentWebview?.launch("https://www.bing.com/");
          String cookie = "";
          while (!cookie.contains("_U=")) {
            await Future.delayed(const Duration(microseconds: 500));
            var temp =
                await currentWebview!.evaluateJavaScript("document.cookie");
            if (temp != null) {
              cookie = temp.substring(1, temp.length - 1);
            }
          }
          cookieCompleter.complete(cookie);
          currentWebview?.close();
        }
      });
  }

  return cookieCompleter.future;
}

Future<String> _getWebViewPath() async {
  final document = await getApplicationDocumentsDirectory();
  return path.join(
    document.path,
    'desktop_webview_window',
  );
}
