import 'package:flutter/material.dart';
import 'package:caretailbooster_sdk/caretailbooster_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String mediaId = 'wXkhs9RBxYY2L812';
    const String userId = '1234567890123456';
    const String crypto =
        '34522f9dcb041c681f55d69e7f2929db79cc2aeab721fb7aeb66053e31c5d8a2';
    const String tagGroupId1 = 'e6b7e7f1-d890-11ef-b526-06dcbba31fd5';
    const String tagGroupId2 = 'a188368b-d89e-11ef-b526-06dcbba31fd5';
    const CaRetailBoosterRunMode runMode = CaRetailBoosterRunMode.dev;

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
                height: 210,
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
