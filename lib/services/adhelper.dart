import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      String testId = 'ca-app-pub-3940256099942544/6300978111';
      String androidId = 'ca-app-pub-8265037961520877/6775890903';
      return androidId;
    }
    else if (Platform.isIOS) {
      String testId = 'ca-app-pub-3940256099942544/2934735716';
      String iosId = 'ca-app-pub-8265037961520877/7171117930';
      return iosId;
    }
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }


  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      String testId = 'ca-app-pub-3940256099942544/8691691433';
      String androidId = 'ca-app-pub-8265037961520877/3492000446';
      return testId;
    }
    else if (Platform.isIOS) {
      String testId = 'ca-app-pub-3940256099942544/5135589807';
      String iosId = 'ca-app-pub-8265037961520877/8424762927';
      return iosId;
    }
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      String testId = 'ca-app-pub-3940256099942544/5224354917';
      String androidId = 'ca-app-pub-8265037961520877/3332218345';
      return testId;
    }
    else if (Platform.isIOS) {
      String testId = 'ca-app-pub-3940256099942544/1712485313';
      String iosId = 'ca-app-pub-8265037961520877/8361183742';
      return iosId;
    }
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

}