import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   String _cookie = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_cookie.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Cookie: $_cookie'),
//               ),
//             ElevatedButton(
//               onPressed: () async {
//                 final cookie = await getCookie(context);
//                 setState(() {
//                   _cookie = cookie;
//                 });
//               },
//               child: const Text('Get Cookie'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://login.live.com/"))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) async {
          if (url.startsWith("https://account.microsoft.com")) {
            await _controller.loadRequest(Uri.parse("https://www.bing.com/"));
            while (!_cookie.contains("_U=")) {
              await Future.delayed(const Duration(microseconds: 500));
              var cookie = await _controller
                  .runJavaScriptReturningResult('document.cookie');
              _cookie = cookie.toString();
            }
            if (context.mounted) {
              // ignore: use_build_context_synchronously
              Navigator.pop(context, _cookie);
            }
          }
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cookie Extractor')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
