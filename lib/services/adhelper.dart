import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      String testId = 'ca-app-pub-3940256099942544/6300978111';
      String androidLiveId = 'ca-app-pub-8265037961520877/9110885565';
      return testId;
    }
    else if (Platform.isIOS) {
      String testId = 'ca-app-pub-3940256099942544/2934735716';
      String iosLiveId = 'ca-app-pub-8265037961520877/7171117930';
      return testId;
    }
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }


  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      String testId = 'ca-app-pub-3940256099942544/8691691433';
      String androidLiveId = '';
      return testId;
    }
    else if (Platform.isIOS) {
      String testId = 'ca-app-pub-3940256099942544/5135589807';
      String iosLiveId = '';
      return testId;
    }
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      String testId = 'ca-app-pub-3940256099942544/5224354917';
      String androidLiveId = '';
      return testId;
    }
    else if (Platform.isIOS) {
      String testId = 'ca-app-pub-3940256099942544/1712485313';
      String iosLiveId = '';
      return testId;
    }
    else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

}