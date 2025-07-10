enum CaRetailBoosterMethodCallType {
  markSucceeded('onMarkSucceeded'),
  rewardModalClosed('onRewardModalClosed'),
  hasAds('hasAds'),
  areaName('areaName'),
  areaDescription('areaDescription');

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
