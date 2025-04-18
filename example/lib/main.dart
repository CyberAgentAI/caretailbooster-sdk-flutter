import 'package:flutter/material.dart';
import 'package:caretailbooster_sdk/caretailbooster_sdk.dart';
import 'package:crypto/crypto.dart'; // SHA-256ハッシュ化のためのパッケージ
import 'dart:convert'; // UTF-8エンコーディングのため

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARetailBooster SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AdScreen(),
    );
  }
}

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final TextEditingController _userIdController = TextEditingController();
  bool _isUserIdSubmitted = false;
  String _userId = '';

  // test_mediaを使用
  final String _clientSecret =
      '2G5tDEJNY7vW5Gw6xqItnAjJz9ghTSwACGf1CygGUsAOeSdyOZ8gHfrbHbsS8fcA';

  String _generateCrypto(String userId) {
    final String combinedString = userId + _clientSecret;
    final List<int> bytes = utf8.encode(combinedString);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String mediaId = '1234567890abcdef';
    const String tagGroupIdReward = '0853bf57-70b4-4ddc-b57c-507c196abfca';
    const String tagGroupIdBanner = 'ac0ebf99-f89f-40e5-95ce-09558cf993cc';
    const CaRetailBoosterRunMode runMode = CaRetailBoosterRunMode.stg;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RetailBooster SDK Example'),
      ),
      body: _isUserIdSubmitted
          ? _buildAdContent(
              mediaId: mediaId,
              userId: _userId,
              crypto: _generateCrypto(_userId),
              tagGroupIdReward: tagGroupIdReward,
              tagGroupIdBanner: tagGroupIdBanner,
              runMode: runMode,
            )
          : _buildUserIdForm(),
    );
  }

  // ユーザーID入力フォーム
  Widget _buildUserIdForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ユーザーIDの設定',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _userIdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ユーザーIDを入力してください',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_userIdController.text.isNotEmpty) {
                setState(() {
                  _userId = _userIdController.text;
                  _isUserIdSubmitted = true;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
            child: const Text('送信'),
          ),
        ],
      ),
    );
  }

  // 広告コンテンツ表示
  Widget _buildAdContent({
    required String mediaId,
    required String userId,
    required String crypto,
    required String tagGroupIdReward,
    required String tagGroupIdBanner,
    required CaRetailBoosterRunMode runMode,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: const Text(
                'Reward Ads',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 8.0),

          // リワード広告
          Container(
            height: 220,
            child: CaRetailBoosterAdView(
              mediaId: mediaId,
              userId: userId,
              crypto: crypto,
              tagGroupId: tagGroupIdReward,
              runMode: runMode,
              onMarkSucceeded: () {
                debugPrint('onMarkSucceeded');
              },
              onRewardModalClosed: () {
                debugPrint('onRewardModalClosed');
              },
              options: const CaRetailBoosterAdOptions(
                width: 173,
                height: 210,
              ),
            ),
          ),

          const SizedBox(height: 24.0),
          const Text(
            'Banner Ads',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),

          // バナー広告
          Container(
            height: 250,
            child: CaRetailBoosterAdView(
              mediaId: mediaId,
              userId: userId,
              crypto: crypto,
              tagGroupId: tagGroupIdBanner,
              runMode: runMode,
            ),
          ),

          const SizedBox(height: 32.0),
          // 再設定ボタン
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userIdController.clear();
                _userId = '';
                _isUserIdSubmitted = false;
              });
            },
            style: ElevatedButton.styleFrom(),
            child: const Text('別のユーザーIDで再設定'),
          ),
        ],
      ),
    );
  }
}
