import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:caretailbooster_sdk/caretailbooster_sdk.dart';
import 'dart:io';

void main() {
  testWidgets('RetailBoosterSdkView widget test', (WidgetTester tester) async {
    const String mediaId = 'media1';
    const String userId = 'user1';
    const String crypto = 'crypto1';
    const String tagGroupId = 'reward1';
    const CaRetailBoosterRunMode runMode = CaRetailBoosterRunMode.stg;

    // ウィジェットをビルド
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CaRetailBoosterAdView(
            mediaId: mediaId,
            userId: userId,
            crypto: crypto,
            tagGroupId: tagGroupId,
            runMode: runMode,
          ),
        ),
      ),
    );

    // レンダリングが完了するまで待機
    await tester.pumpAndSettle();

    // ウィジェットが正常にビルドされたことを確認
    expect(find.byType(CaRetailBoosterAdView), findsOneWidget);

    // プラットフォームによる表示内容の検証
    if (Platform.isIOS) {
      expect(find.byType(UiKitView), findsOneWidget);
    } else if (Platform.isAndroid) {
      expect(find.byType(AndroidView), findsOneWidget);
    } else {
      expect(find.text('未対応のプラットフォームです'), findsOneWidget);
    }
  });
}
