import 'dart:async';
import 'dart:developer';
// import 'dart:developer';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// void main(List<String> args) {
//   debugPrint('args: $args');
//   if (runWebViewTitleBarWidget(args)) {
//     return;
//   }
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const HomePage());
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Home Page'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               getCookie().then((value) {
//                 // log("Finally success: $value");
//               }).catchError((e) {
//                 // log("Finally failed: $e");
//               });
//             },
//             child: const Text('Get Cookie'),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
    currentWebview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        userDataFolderWindows: await _getWebViewPath(),
        titleBarTopPadding: Platform.isMacOS ? 20 : 0,
      ),
    );
    currentWebview
      ..setBrightness(Brightness.dark)
      ..launch(url)
      ..addOnUrlRequestCallback((url) {
        if (url.startsWith("https://account.microsoft.com")) {
          currentWebview?.launch("https://www.bing.com/");
          currentWebview!.evaluateJavaScript("document.cookie").then((value) {
            value = value?.substring(1, value.length - 1);
            log("Succeed to get cookie: $value");
            cookieCompleter.complete(value);
            currentWebview?.close();
          }).catchError((e) {
            log("Failed to get cookie: $e");
            cookieCompleter.completeError(e);
            currentWebview?.close();
          });
        }
      })
      ..onClose.whenComplete(() {});
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
