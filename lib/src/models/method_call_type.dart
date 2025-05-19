enum CaRetailBoosterMethodCallType {
  markSucceeded('onMarkSucceeded'),
  rewardModalClosed('onRewardModalClosed');

  final String methodName;
  const CaRetailBoosterMethodCallType(this.methodName);

  static CaRetailBoosterMethodCallType? fromMethodName(String methodName) {
    try {
      return CaRetailBoosterMethodCallType.values.firstWhere(
        (type) => type.methodName == methodName,
      );
    } catch (e) {
      return null;
    }
  }
}
