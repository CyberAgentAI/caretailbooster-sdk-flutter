import 'package:flutter/material.dart';
import 'package:caretailbooster_sdk/caretailbooster_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CaRetailBoosterAdView adView1;
  late CaRetailBoosterAdView adView2;

  @override
  void initState() {
    super.initState();
    _initializeAdViews();
  }

  void _initializeAdViews() {
    const String mediaId = 'media_id';
    const String userId = 'user_id';
    const String crypto = 'crypto_id';
    const String tagGroupId1 = 'reward1';
    const String tagGroupId2 = 'banner1';
    const CaRetailBoosterRunMode runMode = CaRetailBoosterRunMode.mock;

    adView1 = CaRetailBoosterAdView(
      mediaId: mediaId,
      userId: userId,
      crypto: crypto,
      tagGroupId: tagGroupId1,
      runMode: runMode,
      onMarkSucceeded: () {
        debugPrint('onMarkSucceeded');
      },
      onRewardModalClosed: () {
        debugPrint('onRewardModalClosed');
      },
      hasAds: (bool hasAds) {
        debugPrint('hasAds: $hasAds');
      },
      options: CaRetailBoosterAdOptions(
        width: 173,
        height: 210,
        itemSpacing: 16,
        leadingMargin: 16,
        trailingMargin: 16,
      ),
    );

    adView2 = CaRetailBoosterAdView(
      mediaId: mediaId,
      userId: userId,
      crypto: crypto,
      tagGroupId: tagGroupId2,
      runMode: runMode,
      options: CaRetailBoosterAdOptions(
        width: 173,
        height: 210,
      ),
    );

    // ウィジェットがビルドされた後にFutureを実行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAdViewData();
    });
  }

  void _loadAdViewData() async {
    await Future.wait([
      // adView1のデータ取得
      adView1.hasAdsFuture().then((hasAds) {
        debugPrint('adView1 hasAds: $hasAds');
      }).catchError((error) {
        debugPrint('adView1 hasAds error: $error');
      }),

      adView1.areaNameFuture().then((areaName) {
        debugPrint('adView1 areaName: ${areaName ?? "null"}');
      }).catchError((error) {
        debugPrint('adView1 areaName error: $error');
      }),

      adView1.areaDescriptionFuture().then((areaDescription) {
        debugPrint('adView1 areaDescription: ${areaDescription ?? "null"}');
      }).catchError((error) {
        debugPrint('adView1 areaDescription error: $error');
      }),

      // adView2のデータ取得
      adView2.hasAdsFuture().then((hasAds) {
        debugPrint('adView2 hasAds: $hasAds');
      }).catchError((error) {
        debugPrint('adView2 hasAds error: $error');
      }),

      adView2.areaNameFuture().then((areaName) {
        debugPrint('adView2 areaName: ${areaName ?? "null"}');
      }).catchError((error) {
        debugPrint('adView2 areaName error: $error');
      }),

      adView2.areaDescriptionFuture().then((areaDescription) {
        debugPrint('adView2 areaDescription: ${areaDescription ?? "null"}');
      }).catchError((error) {
        debugPrint('adView2 areaDescription error: $error');
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 210,
                child: adView1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 210,
                child: adView2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
