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

}