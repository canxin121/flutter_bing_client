import 'package:flutter/material.dart';
import 'package:flutter_bing_client/util.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<String> getCookie(BuildContext context) async {
  final cookie = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const WebViewExample(),
    ),
  );

  return cookie;
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  late WebViewController _controller;
  late String _cookie = "";

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    WebViewCookieManager manager = WebViewCookieManager();
    _controller = WebViewController();
    await manager.clearCookies();
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) async {
        if (url.startsWith("https://account.microsoft.com")) {
          await _controller.loadRequest(Uri.parse(
              "https://www.bing.com/chat?q=Microsoft+Copilot&FORM=hpcodx"));
          if (mounted) {
            showInfoSnackBar("如果显示登录,请点击使用个人账户登录", context);
          }
          while (!_cookie.contains("_U=")) {
            await Future.delayed(const Duration(microseconds: 500));
            var cookie = await _controller
                .runJavaScriptReturningResult('document.cookie');
            _cookie = processCookie(cookie.toString());
          }
          if (mounted) {
            Navigator.pop(context, _cookie);
          }
        }
      },
    ));
    await _controller.loadRequest(Uri.parse("https://login.live.com/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cookie Extractor',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: WebViewWidget(controller: _controller),
    );
  }
}

String processCookie(String cookie) {
  while (cookie.startsWith('"')) {
    cookie = cookie.substring(1);
  }
  while (cookie.startsWith("'")) {
    cookie = cookie.substring(1);
  }
  while (cookie.endsWith('"')) {
    cookie = cookie.substring(0, cookie.length - 1);
  }
  while (cookie.endsWith("'")) {
    cookie = cookie.substring(0, cookie.length - 1);
  }
  return cookie;
}
