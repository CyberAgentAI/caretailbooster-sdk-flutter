package com.example.caretailbooster_sdk

import android.content.Context
import android.view.View
import android.os.Handler
import android.os.Looper
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.unit.dp
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import com.retaiboo.caretailboostersdk.useCaRetailBooster
import com.retaiboo.caretailboostersdk.CaRetailBoosterCallback
import com.retaiboo.caretailboostersdk.CaRetailBoosterEnvMode
import com.retaiboo.caretailboostersdk.CaRetailBoosterOptions
import com.retaiboo.caretailboostersdk.CaRetailBoosterRewardAdOptions
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.foundation.background
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.rememberScrollState

class CaRetailBoosterView(
    private val context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    private val mediaId: String,
    private val userId: String,
    private val crypto: String,
    private val tagGroupId: String,
    private val runMode: String,
    private val width: Int?,
    private val height: Int?,
    private val itemSpacing: Double?,
    private val leadingMargin: Double?,
    private val trailingMargin: Double?,
    private val hiddenIndicators: Boolean
) : PlatformView {
    private val channel: MethodChannel = MethodChannel(messenger, "ca_retail_booster_ad_view_$viewId")
    private var adView: View? = null

    init {
        adView = ComposeView(context).apply {
            setContent {
                CaRetailBoosterContent()
            }
            setBackgroundColor(android.graphics.Color.TRANSPARENT)
        }
    }

    @Composable
    private fun CaRetailBoosterContent() {
        // コールバックの実装
        val callback = object : CaRetailBoosterCallback {
            override fun onMarkSucceeded() {
                try {
                    Handler(Looper.getMainLooper()).post {
                        channel.invokeMethod(CaRetailBoosterMethodCallType.MARK_SUCCEEDED.methodName, null)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            override fun onRewardModalClose() {
                try {
                    Handler(Looper.getMainLooper()).post {
                        channel.invokeMethod(CaRetailBoosterMethodCallType.REWARD_MODAL_CLOSED.methodName, null)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }

        // オプションの設定
        val rewardAdOptions = if (width != null || height != null) {
            object : CaRetailBoosterRewardAdOptions {
                override val width = this@CaRetailBoosterView.width
                override val height = this@CaRetailBoosterView.height
            }
        } else null

        val options = if (rewardAdOptions != null) {
            object : CaRetailBoosterOptions {
                override val rewardAd = rewardAdOptions
            }
        } else null

        // 実行モードの変換
        val mode = when (runMode.lowercase()) {
            "local" -> CaRetailBoosterEnvMode.LOCAL
            "dev" -> CaRetailBoosterEnvMode.DEV
            "stg" -> CaRetailBoosterEnvMode.STG
            "prd" -> CaRetailBoosterEnvMode.PRD
            "mock" -> CaRetailBoosterEnvMode.MOCK
            else -> CaRetailBoosterEnvMode.STG
        }

        // SDKの初期化
        val caRetailBoosterResult = useCaRetailBooster(
            context = context,
            mediaId = mediaId,
            userId = userId,
            crypto = crypto,
            tagGroupId = tagGroupId,
            mode = mode,
            callback = callback,
            options = options
        )

        var isFirst by remember { mutableStateOf(true) }
        var prevAds by remember { mutableStateOf<List<Any>>(emptyList()) }
    
        // 広告の有無を通知
        LaunchedEffect(caRetailBoosterResult.ads.hashCode()) {
            val ads = caRetailBoosterResult.ads
            if (isFirst) {
                isFirst = false
            } else if (prevAds != ads) {
                Handler(Looper.getMainLooper()).post {
                    channel.invokeMethod(CaRetailBoosterMethodCallType.HAS_ADS.methodName, ads.isNotEmpty())
                }
            }
            prevAds = ads
        }

        // 広告の表示
        Column {
            Row(
                horizontalArrangement = Arrangement.spacedBy(itemSpacing?.toFloat()?.dp ?: 0.dp),
                modifier = Modifier
                    .background(Color.Transparent)
                    .horizontalScroll(rememberScrollState())
            ) {
                // Rowだとpaddingで要素先頭のmarginと末尾のmarginが取れず、見切れて見えるので、Spacerを入れて調整
                Spacer(
                    modifier = Modifier.padding(start = leadingMargin?.toFloat()?.dp ?: 0.dp)
                )
                caRetailBoosterResult.ads.forEach { ad ->
                    ad()
                }
                Spacer(
                    modifier = Modifier.padding(end = trailingMargin?.toFloat()?.dp ?: 0.dp)
                )
            }
        }
    }

    override fun getView(): View {
        return adView ?: View(context)
    }

    override fun dispose() {
        adView = null
    }
}
