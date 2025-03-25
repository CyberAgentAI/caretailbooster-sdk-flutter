enum CaRetailBoosterCallbackType {
  markSucceeded('onMarkSucceeded'),
  rewardModalClosed('onRewardModalClosed');

  final String methodName;
  const CaRetailBoosterCallbackType(this.methodName);

  static CaRetailBoosterCallbackType? fromMethodName(String methodName) {
    try {
      return CaRetailBoosterCallbackType.values.firstWhere(
        (type) => type.methodName == methodName,
      );
    } catch (e) {
      return null;
    }
  }
} 