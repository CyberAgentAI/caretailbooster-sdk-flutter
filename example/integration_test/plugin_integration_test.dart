// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:caretailbooster_sdk/caretailbooster_sdk.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

    // レイアウトの変更を反映
    await tester.pumpAndSettle();

    // ウィジェットが存在することを確認
    expect(find.byType(CaRetailBoosterAdView), findsOneWidget);

    // プラットフォームによる表示内容の検証
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      expect(find.byType(UiKitView), findsOneWidget);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      expect(find.byType(AndroidView), findsOneWidget);
    } else {
      // 他のプラットフォームでは、代替ウィジェットを確認
      expect(find.text('未対応のプラットフォームです'), findsOneWidget);
    }
  });
}
