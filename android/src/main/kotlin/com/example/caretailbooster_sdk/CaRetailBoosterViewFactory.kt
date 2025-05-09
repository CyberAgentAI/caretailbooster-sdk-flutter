package com.example.caretailbooster_sdk

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class CaRetailBoosterViewFactory(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val arguments = args as? Map<String, Any> ?: mapOf()
        
        return CaRetailBoosterView(
            context,
            messenger,
            viewId,
            arguments["mediaId"] as? String ?: "",
            arguments["userId"] as? String ?: "",
            arguments["crypto"] as? String ?: "",
            arguments["tagGroupId"] as? String ?: "",
            arguments["runMode"] as? String ?: "stg",
            arguments["width"] as? Int,
            arguments["height"] as? Int,
            arguments["itemSpacing"] as? Double,
            arguments["leadingMargin"] as? Double,
            arguments["trailingMargin"] as? Double
        )
    }
}