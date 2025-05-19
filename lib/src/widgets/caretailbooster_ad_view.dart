import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../models/run_mode.dart';
import '../models/ad_options.dart';
import '../models/method_call_type.dart';

class CaRetailBoosterAdView extends StatefulWidget {
  final String mediaId;
  final String userId;
  final String crypto;
  final String tagGroupId;
  final CaRetailBoosterRunMode runMode;
  final CaRetailBoosterAdOptions? options;
  final VoidCallback? onMarkSucceeded;
  final VoidCallback? onRewardModalClosed;

  const CaRetailBoosterAdView({
    super.key,
    required this.mediaId,
    required this.userId,
    required this.crypto,
    required this.tagGroupId,
    required this.runMode,
    this.options,
    this.onMarkSucceeded,
    this.onRewardModalClosed,
  });

  @override
  State<CaRetailBoosterAdView> createState() => _CaRetailBoosterAdViewState();
}

class _CaRetailBoosterAdViewState extends State<CaRetailBoosterAdView> {
  late final MethodChannel _channel;

  @override
  void initState() {
    super.initState();
  }

  void _onPlatformViewCreated(int viewId) {
    _channel = MethodChannel('ca_retail_booster_ad_view_$viewId');
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    final methodCallType =
        CaRetailBoosterMethodCallType.fromMethodName(call.method);

    switch (methodCallType) {
      case CaRetailBoosterMethodCallType.markSucceeded:
        widget.onMarkSucceeded?.call();
        break;
      case CaRetailBoosterMethodCallType.rewardModalClosed:
        widget.onRewardModalClosed?.call();
        break;
      case null:
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'ca_retail_booster_ad_view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{
          'mediaId': widget.mediaId,
          'userId': widget.userId,
          'crypto': widget.crypto,
          'tagGroupId': widget.tagGroupId,
          'runMode': widget.runMode.name,
          'width': widget.options?.width,
          'height': widget.options?.height,
          'itemSpacing': widget.options?.itemSpacing,
          'leadingMargin': widget.options?.leadingMargin,
          'trailingMargin': widget.options?.trailingMargin,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'ca_retail_booster_ad_view',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{
          'mediaId': widget.mediaId,
          'userId': widget.userId,
          'crypto': widget.crypto,
          'tagGroupId': widget.tagGroupId,
          'runMode': widget.runMode.name,
          'width': widget.options?.width,
          'height': widget.options?.height,
          'itemSpacing': widget.options?.itemSpacing,
          'leadingMargin': widget.options?.leadingMargin,
          'trailingMargin': widget.options?.trailingMargin,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Text('未対応のプラットフォームです');
    }
  }

  @override
  void dispose() {
    // チャンネルのクリーンアップ
    _channel.setMethodCallHandler(null);
    super.dispose();
  }
}
