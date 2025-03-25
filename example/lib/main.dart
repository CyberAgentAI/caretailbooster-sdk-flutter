import 'package:flutter/material.dart';
import 'package:caretailbooster_sdk/caretailbooster_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String mediaId = 'media_id';
    const String userId = 'user_id';
    const String crypto = 'crypto_id';
    const String tagGroupId1 = 'reward1';
    const String tagGroupId2 = 'banner1';
    const CaRetailBoosterRunMode runMode = CaRetailBoosterRunMode.mock;

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
                child: CaRetailBoosterAdView(
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
                  options: CaRetailBoosterAdOptions(
                    width: 173,
                    height: 210,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 173,
                child: CaRetailBoosterAdView(
                  mediaId: mediaId,
                  userId: userId,
                  crypto: crypto,
                  tagGroupId: tagGroupId2,
                  runMode: runMode,
                  options: CaRetailBoosterAdOptions(
                    width: 173,
                    height: 210,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
