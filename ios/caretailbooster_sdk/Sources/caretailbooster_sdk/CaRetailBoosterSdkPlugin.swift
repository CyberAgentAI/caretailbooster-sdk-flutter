import Flutter
import UIKit
import SwiftUI

public class CaRetailBoosterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Platform View のファクトリを登録
    let factory = SwiftUIViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "ca_retail_booster_ad_view")
  }
}
