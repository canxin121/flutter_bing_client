// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.30.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'package:get/get.dart';

import 'api/bing_client_types.dart';
import 'api/bing_client_wrap.dart';
import 'api/init.dart';
import 'api/utils.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.io.dart' if (dart.library.html) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.initApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.0.0-dev.30';

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_flutter_bing_client',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Stream<String> askStreamPlain(
      {required WrappedChat chat,
      required String textMsg,
      String? imagePath,
      dynamic hint});

  Future<String> createChat({dynamic hint});

  Future<void> deleteChat({required String id, dynamic hint});

  Future<void> deleteChats({required List<String> ids, dynamic hint});

  Future<DisplayConfig> displayGlobalState({dynamic hint});

  Future<List<WrappedMsg>> getChatMsgs({required String id, dynamic hint});

  Future<List<WrappedChat>> getUpdateChatList({dynamic hint});

  Future<void> recreateClientSave({required String cookieStr, dynamic hint});

  Future<void> renameChat(
      {required String id, required String newName, dynamic hint});

  Future<void> stopAnswer({required String id, dynamic hint});

  Future<void> tryLoadClient({dynamic hint});

  Future<void> initApp({dynamic hint});

  Future<void> initLogger({dynamic hint});

  Future<void> initRootPath({required String path, dynamic hint});

  Future<String> genTimeLocal({int? time, dynamic hint});

  String generateUuidv4String({dynamic hint});

  String readFile({required String path, dynamic hint});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Stream<String> askStreamPlain(
      {required WrappedChat chat,
      required String textMsg,
      String? imagePath,
      dynamic hint}) {
    return handler.executeStream(StreamTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_box_autoadd_wrapped_chat(chat, serializer);
        sse_encode_String(textMsg, serializer);
        sse_encode_opt_String(imagePath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 9, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kAskStreamPlainConstMeta,
      argValues: [chat, textMsg, imagePath],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kAskStreamPlainConstMeta => const TaskConstMeta(
        debugName: "ask_stream_plain",
        argNames: ["chat", "textMsg", "imagePath"],
      );

  @override
  Future<String> createChat({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCreateChatConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kCreateChatConstMeta => const TaskConstMeta(
        debugName: "create_chat",
        argNames: [],
      );

  @override
  Future<void> deleteChat({required String id, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(id, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 8, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kDeleteChatConstMeta,
      argValues: [id],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kDeleteChatConstMeta => const TaskConstMeta(
        debugName: "delete_chat",
        argNames: ["id"],
      );

  @override
  Future<void> deleteChats({required List<String> ids, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_list_String(ids, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 11, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kDeleteChatsConstMeta,
      argValues: [ids],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kDeleteChatsConstMeta => const TaskConstMeta(
        debugName: "delete_chats",
        argNames: ["ids"],
      );

  @override
  Future<DisplayConfig> displayGlobalState({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 1, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_display_config,
        decodeErrorData: null,
      ),
      constMeta: kDisplayGlobalStateConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kDisplayGlobalStateConstMeta => const TaskConstMeta(
        debugName: "display_global_state",
        argNames: [],
      );

  @override
  Future<List<WrappedMsg>> getChatMsgs({required String id, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(id, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_wrapped_msg,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kGetChatMsgsConstMeta,
      argValues: [id],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetChatMsgsConstMeta => const TaskConstMeta(
        debugName: "get_chat_msgs",
        argNames: ["id"],
      );

  @override
  Future<List<WrappedChat>> getUpdateChatList({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_wrapped_chat,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kGetUpdateChatListConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGetUpdateChatListConstMeta => const TaskConstMeta(
        debugName: "get_update_chat_list",
        argNames: [],
      );

  @override
  Future<void> recreateClientSave({required String cookieStr, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(cookieStr, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kRecreateClientSaveConstMeta,
      argValues: [cookieStr],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kRecreateClientSaveConstMeta => const TaskConstMeta(
        debugName: "recreate_client_save",
        argNames: ["cookieStr"],
      );

  @override
  Future<void> renameChat(
      {required String id, required String newName, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(id, serializer);
        sse_encode_String(newName, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kRenameChatConstMeta,
      argValues: [id, newName],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kRenameChatConstMeta => const TaskConstMeta(
        debugName: "rename_chat",
        argNames: ["id", "newName"],
      );

  @override
  Future<void> stopAnswer({required String id, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(id, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 10, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kStopAnswerConstMeta,
      argValues: [id],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kStopAnswerConstMeta => const TaskConstMeta(
        debugName: "stop_answer",
        argNames: ["id"],
      );

  @override
  Future<void> tryLoadClient({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 2, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kTryLoadClientConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kTryLoadClientConstMeta => const TaskConstMeta(
        debugName: "try_load_client",
        argNames: [],
      );

  @override
  Future<void> initApp({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 12, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitAppConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  @override
  Future<void> initLogger({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 14, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitLoggerConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitLoggerConstMeta => const TaskConstMeta(
        debugName: "init_logger",
        argNames: [],
      );

  @override
  Future<void> initRootPath({required String path, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(path, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 13, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitRootPathConstMeta,
      argValues: [path],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitRootPathConstMeta => const TaskConstMeta(
        debugName: "init_root_path",
        argNames: ["path"],
      );

  @override
  Future<String> genTimeLocal({int? time, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_opt_box_autoadd_u_64(time, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 17, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kGenTimeLocalConstMeta,
      argValues: [time],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGenTimeLocalConstMeta => const TaskConstMeta(
        debugName: "gen_time_local",
        argNames: ["time"],
      );

  @override
  String generateUuidv4String({dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 15)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kGenerateUuidv4StringConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGenerateUuidv4StringConstMeta => const TaskConstMeta(
        debugName: "generate_uuidv4_string",
        argNames: [],
      );

  @override
  String readFile({required String path, dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(path, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 16)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kReadFileConstMeta,
      argValues: [path],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kReadFileConstMeta => const TaskConstMeta(
        debugName: "read_file",
        argNames: ["path"],
      );

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as bool;
  }

  @protected
  int dco_decode_box_autoadd_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_u_64(raw);
  }

  @protected
  WrappedChat dco_decode_box_autoadd_wrapped_chat(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_wrapped_chat(raw);
  }

  @protected
  DisplayConfig dco_decode_display_config(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return DisplayConfig(
      state: dco_decode_bool(arr[0]),
      rootPath: dco_decode_String(arr[1]),
      cookie: dco_decode_String(arr[2]),
      chatListLen: dco_decode_u_32(arr[3]),
      stopSignalLen: dco_decode_u_32(arr[4]),
    );
  }

  @protected
  List<String> dco_decode_list_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_String).toList();
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  List<WrappedChat> dco_decode_list_wrapped_chat(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_wrapped_chat).toList();
  }

  @protected
  List<WrappedMsg> dco_decode_list_wrapped_msg(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_wrapped_msg).toList();
  }

  @protected
  String? dco_decode_opt_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw == null ? null : dco_decode_String(raw);
  }

  @protected
  int? dco_decode_opt_box_autoadd_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw == null ? null : dco_decode_box_autoadd_u_64(raw);
  }

  @protected
  int dco_decode_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  int dco_decode_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeI64OrU64(raw);
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  WrappedChat dco_decode_wrapped_chat(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return WrappedChat(
      conversationId: dco_decode_String(arr[0]),
      chatName: dco_decode_String(arr[1]).obs,
      tone: dco_decode_String(arr[2]),
      updateTimeLocal: dco_decode_String(arr[3]),
      plugins: dco_decode_list_String(arr[4]),
    );
  }

  @protected
  WrappedMsg dco_decode_wrapped_msg(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return WrappedMsg(
      author: dco_decode_String(arr[0]),
      text: dco_decode_String(arr[1]),
    );
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  int sse_decode_box_autoadd_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_u_64(deserializer));
  }

  @protected
  WrappedChat sse_decode_box_autoadd_wrapped_chat(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_wrapped_chat(deserializer));
  }

  @protected
  DisplayConfig sse_decode_display_config(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_state = sse_decode_bool(deserializer);
    var var_rootPath = sse_decode_String(deserializer);
    var var_cookie = sse_decode_String(deserializer);
    var var_chatListLen = sse_decode_u_32(deserializer);
    var var_stopSignalLen = sse_decode_u_32(deserializer);
    return DisplayConfig(
        state: var_state,
        rootPath: var_rootPath,
        cookie: var_cookie,
        chatListLen: var_chatListLen,
        stopSignalLen: var_stopSignalLen);
  }

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <String>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_String(deserializer));
    }
    return ans_;
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  List<WrappedChat> sse_decode_list_wrapped_chat(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <WrappedChat>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_wrapped_chat(deserializer));
    }
    return ans_;
  }

  @protected
  List<WrappedMsg> sse_decode_list_wrapped_msg(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <WrappedMsg>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_wrapped_msg(deserializer));
    }
    return ans_;
  }

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    if (sse_decode_bool(deserializer)) {
      return (sse_decode_String(deserializer));
    } else {
      return null;
    }
  }

  @protected
  int? sse_decode_opt_box_autoadd_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    if (sse_decode_bool(deserializer)) {
      return (sse_decode_box_autoadd_u_64(deserializer));
    } else {
      return null;
    }
  }

  @protected
  int sse_decode_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint32();
  }

  @protected
  int sse_decode_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint64();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  WrappedChat sse_decode_wrapped_chat(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_conversationId = sse_decode_String(deserializer);
    var var_chatName = sse_decode_String(deserializer);
    var var_tone = sse_decode_String(deserializer);
    var var_updateTimeLocal = sse_decode_String(deserializer);
    var var_plugins = sse_decode_list_String(deserializer);
    return WrappedChat(
        conversationId: var_conversationId,
        chatName: var_chatName.obs,
        tone: var_tone,
        updateTimeLocal: var_updateTimeLocal,
        plugins: var_plugins);
  }

  @protected
  WrappedMsg sse_decode_wrapped_msg(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_author = sse_decode_String(deserializer);
    var var_text = sse_decode_String(deserializer);
    return WrappedMsg(author: var_author, text: var_text);
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ((');
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_box_autoadd_u_64(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_u_64(self, serializer);
  }

  @protected
  void sse_encode_box_autoadd_wrapped_chat(
      WrappedChat self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_wrapped_chat(self, serializer);
  }

  @protected
  void sse_encode_display_config(DisplayConfig self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_bool(self.state, serializer);
    sse_encode_String(self.rootPath, serializer);
    sse_encode_String(self.cookie, serializer);
    sse_encode_u_32(self.chatListLen, serializer);
    sse_encode_u_32(self.stopSignalLen, serializer);
  }

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_String(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_list_wrapped_chat(
      List<WrappedChat> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_wrapped_chat(item, serializer);
    }
  }

  @protected
  void sse_encode_list_wrapped_msg(
      List<WrappedMsg> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_wrapped_msg(item, serializer);
    }
  }

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_String(self, serializer);
    }
  }

  @protected
  void sse_encode_opt_box_autoadd_u_64(int? self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_box_autoadd_u_64(self, serializer);
    }
  }

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint32(self);
  }

  @protected
  void sse_encode_u_64(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint64(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_wrapped_chat(WrappedChat self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.conversationId, serializer);
    sse_encode_String(self.chatName.value, serializer);
    sse_encode_String(self.tone, serializer);
    sse_encode_String(self.updateTimeLocal, serializer);
    sse_encode_list_String(self.plugins, serializer);
  }

  @protected
  void sse_encode_wrapped_msg(WrappedMsg self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.author, serializer);
    sse_encode_String(self.text, serializer);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }
}
