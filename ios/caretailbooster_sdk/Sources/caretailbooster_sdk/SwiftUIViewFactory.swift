import Flutter
import UIKit

class SwiftUIViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    @MainActor
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments: Any?
    ) -> FlutterPlatformView {
        guard
            let args = arguments as? [String: Any],
            let mediaId = args["mediaId"] as? String,
            let userId = args["userId"] as? String,
            let crypto = args["crypto"] as? String,
            let tagGroupId = args["tagGroupId"] as? String,
            let runMode = args["runMode"] as? String
        else {
            fatalError("Invalid arguments")
        }

        return SwiftUIView(
            frame: frame,
            messenger: messenger,
            viewId: viewId,
            mediaId: mediaId,
            userId: userId,
            crypto: crypto,
            tagGroupId: tagGroupId,
            runMode: runMode,
            width: args["width"] as? Int,
            height: args["height"] as? Int
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}