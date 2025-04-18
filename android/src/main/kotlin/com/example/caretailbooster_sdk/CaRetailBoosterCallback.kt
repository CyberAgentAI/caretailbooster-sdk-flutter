package com.example.caretailbooster_sdk

enum class CaRetailBoosterCallbackType(val methodName: String) {
    MARK_SUCCEEDED("onMarkSucceeded"),
    REWARD_MODAL_CLOSED("onRewardModalClosed");
    
    companion object {
        fun fromMethodName(methodName: String): CaRetailBoosterCallbackType? {
            return values().find { it.methodName == methodName }
        }
    }
}

interface CaRetailBoosterCallback {
    fun onMarkSucceeded()
    fun onRewardModalClosed()
}