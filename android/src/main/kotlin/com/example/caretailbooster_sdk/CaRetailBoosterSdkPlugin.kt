package com.example.caretailbooster_sdk

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** CaRetailBoosterSdkPlugin */
class CaRetailBoosterSdkPlugin : FlutterPlugin {
  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    // Platform View のファクトリを登録
    binding.platformViewRegistry.registerViewFactory(
      "ca_retail_booster_ad_view",
      CaRetailBoosterViewFactory(binding.binaryMessenger)
    )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}