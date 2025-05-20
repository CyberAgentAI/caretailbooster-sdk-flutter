package com.example.caretailbooster_sdk

enum class CaRetailBoosterMethodCallType(val methodName: String) {
    MARK_SUCCEEDED("onMarkSucceeded"),
    REWARD_MODAL_CLOSED("onRewardModalClosed"),
    HAS_ADS("hasAds");
    
    companion object {
        fun fromMethodName(methodName: String): CaRetailBoosterMethodCallType? {
            return values().find { it.methodName == methodName }
        }
    }
}

interface CaRetailBoosterCallback {
    fun onMarkSucceeded()
    fun onRewardModalClosed()
}