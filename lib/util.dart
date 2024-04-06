import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showErrorSnackBar(String message, BuildContext context) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
    ),
  );
}

void showInfoSnackBar(String message, BuildContext context) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(
      message: message,
    ),
  );
}

void showSuccessSnackBar(String message, BuildContext context) {
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
