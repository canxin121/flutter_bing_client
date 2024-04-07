// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.30.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'bing_client_types.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `BING_CLIENT` is not used by any `pub` functions, thus it is ignored.
// The type `CHAT_LIST` is not used by any `pub` functions, thus it is ignored.
// The type `ROOT_PATH` is not used by any `pub` functions, thus it is ignored.
// The type `STOP_SIGNALS` is not used by any `pub` functions, thus it is ignored.

Future<DisplayConfig> displayGlobalState({dynamic hint}) =>
    RustLib.instance.api.displayGlobalState(hint: hint);

Future<void> tryLoadClient({dynamic hint}) =>
    RustLib.instance.api.tryLoadClient(hint: hint);

Future<void> recreateClientSave({required String cookieStr, dynamic hint}) =>
    RustLib.instance.api.recreateClientSave(cookieStr: cookieStr, hint: hint);

Future<List<WrappedChat>> getUpdateChatList({dynamic hint}) =>
    RustLib.instance.api.getUpdateChatList(hint: hint);

Future<List<WrappedMsg>> getChatMsgs({required String id, dynamic hint}) =>
    RustLib.instance.api.getChatMsgs(id: id, hint: hint);

Future<String> createChat({dynamic hint}) =>
    RustLib.instance.api.createChat(hint: hint);

Future<void> renameChat(
        {required String id, required String newName, dynamic hint}) =>
    RustLib.instance.api.renameChat(id: id, newName: newName, hint: hint);

Future<void> deleteChat({required String id, dynamic hint}) =>
    RustLib.instance.api.deleteChat(id: id, hint: hint);

Stream<String> askStreamPlain(
        {required WrappedChat chat,
        required String textMsg,
        String? imagePath,
        dynamic hint}) =>
    RustLib.instance.api.askStreamPlain(
        chat: chat, textMsg: textMsg, imagePath: imagePath, hint: hint);

Future<void> stopAnswer({required String id, dynamic hint}) =>
    RustLib.instance.api.stopAnswer(id: id, hint: hint);

Future<void> deleteChats({required List<String> ids, dynamic hint}) =>
    RustLib.instance.api.deleteChats(ids: ids, hint: hint);
