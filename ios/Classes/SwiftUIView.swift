import Flutter
import UIKit
import SwiftUI
import CaRetailBoosterSDK

extension View {
    @ViewBuilder
    func compatibleIgnoreSafeArea() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea(.all)
        } else {
            self.edgesIgnoringSafeArea(.all)
        }
    }
}

class SwiftUIView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private let channel: FlutterMethodChannel
    private var retailBoosterAd: RetailBoosterAd
    private let hostingController: UIHostingController<AnyView>
    private let itemSpacing: CGFloat?
    private let leadingMargin: CGFloat?
    private let trailingMargin: CGFloat?
    private let hiddenIndicators: Bool
    private let tagGroupId: String
    private var isLoadingData = false
    
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
        trailingMargin: CGFloat?,
        hiddenIndicators: Bool
    ) {
        channel = FlutterMethodChannel(name: "ca_retail_booster_ad_view_\(viewId)", binaryMessenger: messenger)
        weak var weakChannel = channel
        _view = UIView(frame: frame)

        hostingController = UIHostingController(rootView: AnyView(EmptyView()))
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        _view.addSubview(hostingController.view)
        // 親View(_view)に上端、左端、右端を合わせる制約を追加
        // TOOD: この設定だと下端が想定よりも大きくなってしまい、FluuterのWidgetと合わない。他コンテンツへの影響はないので、一旦TODOにしている。
        hostingController.view.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
        hostingController.view.leadingAnchor.constraint(equalTo: _view.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: _view.trailingAnchor).isActive = true
        
        self.tagGroupId = tagGroupId
        self.itemSpacing = itemSpacing
        self.leadingMargin = leadingMargin
        self.trailingMargin = trailingMargin
        self.hiddenIndicators = hiddenIndicators

        // コールバックの初期化
        let callback = Callback(
            onMarkSucceeded: {
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.markSucceeded.rawValue, arguments: nil)
            },
            onRewardModalClosed: {
                weakChannel?.invokeMethod(CaRetailBoosterMethodCallType.rewardModalClosed.rawValue, arguments: nil)
            }
        )
        
        // RetailBoosterAdの初期化
        retailBoosterAd = RetailBoosterAd(
            mediaId: mediaId,
            userId: userId,
            crypto: crypto,
            tagGroupId: tagGroupId,
            mode: .init(rawValue: runMode) ?? .stg,
            callback: callback,
            options: .init(rewardAd: RewardAdOption(
                    width: width,
                    height: height
                )
            )
        )

        super.init()
        
        SwiftUIViewNotification.registerView(self, tagGroupId: tagGroupId)
        
        loadAds()
    }
    
    // 広告データの読み込みメソッド
    @MainActor
    func loadAds() {
        if isLoadingData { return }
        isLoadingData = true
        
        retailBoosterAd.getAdViews { [weak self] result in
            guard let self = self else { return }
            self.isLoadingData = false
            
            if case .success(let adViews) = result, !adViews.isEmpty {
                self.updateUI(with: adViews)
                self.channel.invokeMethod(CaRetailBoosterMethodCallType.areaName.rawValue, arguments: retailBoosterAd.areaName)
                self.channel.invokeMethod(CaRetailBoosterMethodCallType.areaDescription.rawValue, arguments: retailBoosterAd.areaDescription)
                self.channel.invokeMethod(CaRetailBoosterMethodCallType.hasAds.rawValue, arguments: true)
            } else {
                self.channel.invokeMethod(CaRetailBoosterMethodCallType.hasAds.rawValue, arguments: false)
            }
        }
    }

    private func updateUI(with adViews: [AnyView]) {
        self.hostingController.rootView = AnyView(self.createAdScrollView(with: adViews))
    }

    private func createAdScrollView(with adViews: [AnyView]) -> some View {
        ScrollView(.horizontal, showsIndicators: !hiddenIndicators) {
            HStack(spacing: itemSpacing ?? 0) {
                if let leadingMargin = leadingMargin, leadingMargin > 0 {
                    Spacer().frame(width: leadingMargin)
                }
                ForEach(0..<adViews.count, id: \.self) { index in
                    adViews[index]
                }
                if let trailingMargin = trailingMargin, trailingMargin > 0 {
                    Spacer().frame(width: trailingMargin)
                }
            }
        }
        .compatibleIgnoreSafeArea()
    }

    func view() -> UIView {
        _view
    }
    
    deinit {
        SwiftUIViewNotification.unregisterView(self, tagGroupId: tagGroupId)
    }
}
