import Flutter
import UIKit
import SwiftUI
import CaRetailBoosterSDK

class SwiftUIView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private let channel: FlutterMethodChannel

    @MainActor
    init(
        frame: CGRect,
        messenger: FlutterBinaryMessenger,
        viewId: Int64,
        mediaId: String,
        userId: String,
        crypto: String,
        tagGroupId: String,
        runMode: String,
        width: Int?,
        height: Int?,
        itemSpacing: CGFloat?,
        leadingMargin: CGFloat?,
        trailingMargin: CGFloat?
    ) {
        channel = FlutterMethodChannel(name: "ca_retail_booster_ad_view_\(viewId)", binaryMessenger: messenger)
        weak var weakChannel = channel
        let swiftUIView = RetailBoosterAdView(
            mediaId: mediaId,
            userId: userId,
            crypto: crypto,
            tagGroupId: tagGroupId,
            mode: .init(rawValue: runMode) ?? .stg,
            callback: Callback(
                onMarkSucceeded: {
                    weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.markSucceeded.rawValue, arguments: nil)
                },
                onRewardModalClosed: {
                    weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.rewardModalClosed.rawValue, arguments: nil)
                }
            ),
            options: .init(
                rewardAd: .init(width: width, height: height),
                rewardAdItemSpacing: itemSpacing,
                rewardAdLeadingMargin: leadingMargin,
                rewardAdTrailingMargin: trailingMargin
            )
        )
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.frame = frame
        hostingController.view.backgroundColor = .clear

        _view = hostingController.view
        super.init()
    }

    func view() -> UIView {
        _view
    }
}