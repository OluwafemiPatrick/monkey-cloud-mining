import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcm/services/adhelper.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/getters_and_setters.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MokTokenEarning extends StatefulWidget {

  @override
  _MokTokenEarningState createState() => _MokTokenEarningState();
}

class _MokTokenEarningState extends State<MokTokenEarning> {

  Timer _secTimer, _minTimer, _hourTimer;
  SharedPreferences prefs;

  static int _totalDuration = 28799;
  String _mokEarningForActiveSession='0.0000', _currentTime;
  int _hour=0, _minutes=0, _seconds=0;
  int _counterLeft;

  bool _isMinRunning, _isHourRunning;


  @override
  void initState() {
    _getTimeLine();
    _getReferredByCode();
    myBanner.load();
    super.initState();
  }


  @override
  void dispose() {
    _timerDisposedAt();

    _secTimer.cancel();
    _minTimer.cancel();
    _hourTimer.cancel();
    _isMinRunning = false;
    _isHourRunning = false;
    myBanner.dispose();
    super.dispose();
  }

  _timerDisposedAt() async {
    prefs = await SharedPreferences.getInstance();
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    String currentTime = (ms / 1000).round().toString();
    if (isCounterActive == true) {
      prefs.setString("timerDisposedAt", currentTime);
      print ("COUNTER TIMER DISPOSED AT $currentTime");
      isCounterActive = false;
    }

  }


  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    size: AdSize.fullBanner,
    request: AdRequest(),
    listener: AdListener(),
  );

  final AdListener listener = AdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded successfully.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      print('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onApplicationExit: (Ad ad) => print('Left application.'),
  );


  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: myBanner);
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: colorBgLighter,
            title: mcmLogo(),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom: 10.0),
          color: colorBgMain,
          child: Column(
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                SizedBox(height: 20.0,),
                accountCounter(),
                Expanded(child: Container(
                  alignment: Alignment.center,
                  child: adWidget,
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                )),
                // stopMining(),
              ] ),
        )
    );
  }

  Widget accountCounter() {
    double usdEarning = double.parse(_mokEarningForActiveSession) * 0.001;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
      padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: colorBlue,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MOK Token Earning', style: TextStyle(fontSize: 14.0, color: colorWhite),),
            Container(
                height: 60.0,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image.asset('assets/icons/logo.png', height: 50.0, width: 50.0,)
                      ),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_mokEarningForActiveSession MOK ',
                              style: TextStyle(fontSize: 20.0, color: colorWhite)),
                          Row(
                            children: [
                              Spacer(flex: 1),
                              Text('\$' + usdEarning.toStringAsFixed(4) + ' USD',
                                  style: TextStyle(fontSize: 12.0, color: colorWhite)),
                              Spacer(flex: 6),
                            ],),
                        ],)
                      ),
                    ] )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Mining Activity Counter', style: TextStyle(fontSize: 14.0, color: colorWhite),),
            ),
            Center(
              child: Text('$_hour:$_minutes:$_seconds',
                  style: TextStyle(fontSize: 18.0, color: colorWhite)),
            ),
          ]),
    );
  }

  Widget stopMining() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50.0,
      child: isCounterActive
          ? ElevatedButton(
        child: Text('Stop Mining', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          setState(() {
            isCounterActive = false;
            _isMinRunning = false;
            _isHourRunning = false;
            _secTimer.cancel();
          });
          print ('IS COUNTER ACTIVE IS: ' + isCounterActive.toString());
        },
      )
          : ElevatedButton(
        child: Text('Start Mining', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          setState(() => isCounterActive = true );
          _getTimeLine();
          print ('IS COUNTER ACTIVE IS: ' + isCounterActive.toString());
        },
      ),
    );
  }


  _calculateRemainingTime() {
    _calculateEarningForSession();
    var hourLeft = (_counterLeft ~/ 3600).toString();

    if (int.parse(hourLeft) > 0) {
      var hourInSeconds = int.parse(hourLeft) * 3600;
      var minutesLeft = ((_counterLeft-hourInSeconds) ~/ 60).toString();

      if (int.parse(minutesLeft) > 0) {
        var minutesInSeconds = (int.parse(minutesLeft) * 60) + hourInSeconds;
        var secondsLeft = _counterLeft - minutesInSeconds;
        setState(() {
          _hour = int.parse(hourLeft);
          _minutes = int.parse(minutesLeft);
          _seconds = secondsLeft;
        });
        _startTimer();
      }
      else {
        var secondsLeft = _counterLeft - hourInSeconds;
        setState(() {
          _hour = int.parse(hourLeft);
          _minutes = int.parse(minutesLeft);
          _seconds = secondsLeft;
        });
        _startTimer();
      }
    }
    else {
      var minutesLeft = (_counterLeft ~/ 60).toString();
      if (int.parse(minutesLeft) > 0) {
        var minutesInSeconds = (int.parse(minutesLeft) * 60);
        var secondsLeft = _counterLeft - minutesInSeconds;
        setState(() {
          _hour = int.parse(hourLeft);
          _minutes = int.parse(minutesLeft);
          _seconds = secondsLeft;
        });
        _startTimer();
      }
      else {
        var secondsLeft = _counterLeft;
        setState(() {
          _hour = int.parse(hourLeft);
          _minutes = int.parse(minutesLeft);
          _seconds = secondsLeft;
        });
        _startTimer();
      }
    }
  }

  _getTimeLine() async {
    prefs = await SharedPreferences.getInstance();
    var ms = (new DateTime.now()).microsecondsSinceEpoch;

    String currentTime = (ms / 1000).round().toString();
    String timerDisposedAt = prefs.getString("timerDisposedAt");
    int counterV = prefs.getInt('counterValue');

    if (counterV==null || counterV==0){
      setState(() {
        _counterLeft = _totalDuration;
        _isMinRunning = false;
        _isHourRunning = false;
      });
      print ('METHOD ONE 1 EXECUTED');
      _calculateRemainingTime();
    }

    else {

      if (timerDisposedAt != null){
        int timeDiffV = int.parse(currentTime) - int.parse(timerDisposedAt);
        double timeDiffInSec = timeDiffV / 1000;
        double timeLeftV = counterV - timeDiffInSec;

        print ('TIME DIFFERENCE BETWEEN CLOSING AND REOPENING IS : $timeDiffInSec');

        if (timeLeftV >= 0) {
          setState(() {
            _counterLeft = timeLeftV.toInt();
            _isMinRunning = false;
            _isHourRunning = false;
          });
          print ('METHOD TWO 2 EXECUTED');

          _calculateRemainingTime();
        }
        else if (timeLeftV < 0) {
          _updateTokenBalance();
          prefs.remove("counterValue");
          prefs.remove("timerDisposedAt");
          print ('METHOD THREE 3 EXECUTED');

        }
      }
      else if (timerDisposedAt == null){
        setState(() {
          _counterLeft = counterV;
          _isMinRunning = false;
          _isHourRunning = false;
        });
        print ('METHOD FOUR 4 EXECUTED');

        _calculateRemainingTime();
      }
    }
  }

  _calculateEarningForSession() {

    double ePerSec = 1000 / (3 * 28800);
    var elapsedSec = 28800 - _counterLeft;
    double currentEarning = elapsedSec * ePerSec;

    setState(() {
      _mokEarningForActiveSession = currentEarning.toStringAsFixed(4);
    });

  }

  _startMinTimer() async {
    setState(() => _isMinRunning = true);
    var minDuration = Duration(seconds: 60);

    _minTimer = new Timer.periodic(minDuration, (timer) {
      if (_isMinRunning == true) {
        if (_counterLeft == 0){
          setState(() {
            _minTimer.cancel();
            timer.cancel();
          });
        }
        if (_counterLeft>0 && _minutes==0){
          if (_isHourRunning == false){
            setState(() => _hour -- );
            _startHourTimer();
          }
          setState(() => _minutes = 59 );
        }
        else {
          _calculateEarningForSession();
          setState(() => _minutes -- );
        }
      }
      else {
        timer.cancel();
      }
    });
  }

  _startHourTimer() {
    setState(() => _isHourRunning = true);
    var hourDuration = Duration(seconds: 3600);

    _hourTimer = new Timer.periodic(hourDuration, (timer) {
      if (_isHourRunning == true) {
        if (_counterLeft == 0){
          setState(() {
            _hourTimer.cancel();
            timer.cancel();
          });
        }
        else {
          setState(() => _hour -- );
        }
      } else {
        timer.cancel();
      }
    });

  }

  _startTimer()  async {
    var secDuration = Duration(seconds: 1);
    prefs = await SharedPreferences.getInstance();
    isCounterActive = true;

    _secTimer = new Timer.periodic(secDuration, (timer) {
      _counterLeft --;
      print ("COUNTER IS $_counterLeft");
      prefs.setInt("counterValue", _counterLeft);

      if (_counterLeft == 0){
        _updateTokenBalance();
        setState(() {
          _secTimer.cancel();
          timer.cancel();
          isCounterActive = false;
        });
        prefs.remove("counterValue");
      }
      if (_counterLeft>0 && _seconds==0){
        if (_isMinRunning == false){
          setState(() => _minutes -- );
          _startMinTimer();
        }
        setState(() => _seconds = 59 );

      }
      else {
        setState(() => _seconds --);
      }
    });
  }

  _getReferredByCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var refCode = prefs.getString("referredByCode");
    print ("MY REFEREE REFERRAL CODE IS $refCode");
  }


  Future _updateTokenBalance() async {
    _currentTimeInSeconds();
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();
    prefs = await SharedPreferences.getInstance();

    String totalBal = prefs.getString("tokenBalance");
    String numOfSessions = prefs.getString("totalMiningSessions");
    String totalTokenEarned = prefs.getString("totalTokenEarned");

    var totalTokenMined;
    var availableTokenBalance;
    var newBal = double.parse(totalBal) + (1000 / 3);
    var newNumOfSessions = int.parse(numOfSessions) + 1;
    var newTotalTokenEarned = double.parse(totalTokenEarned) + (1000 / 3);

    prefs.setString("tokenBalance", newBal.toStringAsFixed(4));
    prefs.setString("totalMiningSessions", newNumOfSessions.toString());
    prefs.setString("totalTokenEarned", newTotalTokenEarned.toStringAsFixed(4));

    profileRef.child("user_profile").child(prefs.getString("currentUser")).update({
      "mokTokenBalance" : newBal.toStringAsFixed(4),
      "totalMiningSessions" : newNumOfSessions.toString(),
      "totalTokenEarned" : newTotalTokenEarned.toStringAsFixed(4),
    });

    _sendReferralBonus(newNumOfSessions.toString());

    profileRef.child("stakes").child(prefs.getString("currentUser")).child(_currentTime).set({
      "amount" : "333.3333",
      "time" : getCurrentTime(),
    });

    profileRef.child("mcm_details").once().then((DataSnapshot snapshot) {
      totalTokenMined = snapshot.value["totalTokenMined"];
      availableTokenBalance = snapshot.value["availableTokenBalance"];
    }).then((value) {
      var newTotalTokenMined = double.parse(totalTokenMined) + 333.3333;
      var newAvailableTokenBal = double.parse(availableTokenBalance) + 333.3333;
      profileRef.child("mcm_details").update({
        "totalTokenMined" : newTotalTokenMined.toStringAsFixed(4),
        "availableTokenBalance" : newAvailableTokenBal.toStringAsFixed(4),
      });
      print ("EXITING BALANCE UPDATE METHOD");
    });

  }


  Future _sendReferralBonus(String totalMiningSession) async {
    DatabaseReference refRef = FirebaseDatabase.instance.reference().child("referral_ids");
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");

    prefs = await SharedPreferences.getInstance();
    var refCode = prefs.getString("referredByCode");

    if (totalMiningSession == '2') {
      refRef.child(refCode).once().then((DataSnapshot snapshot) {

        String earned2Times = snapshot.value["users_earned_two"];
        String refereeId = snapshot.value["myUserId"];
        int earning = int.parse(earned2Times) + 1 ;

        refRef.child(refCode).update({
          "users_earned_two" : earning.toString()
        });

        profileRef.child(refereeId).once().then((DataSnapshot snapshot) {
          String mokTokenBal = snapshot.value["mokTokenBalance"];
          double newBal = double.parse(mokTokenBal) + 200;

          profileRef.child(refereeId).update({
            "mokTokenBalance" : newBal.toStringAsFixed(4),
          });
        });
      });
    }
    else if (totalMiningSession == '5') {
      refRef.child(refCode).once().then((DataSnapshot snapshot) {

        String earned5Times = snapshot.value["users_earned_five"];
        String refereeId = snapshot.value["myUserId"];
        int earning = int.parse(earned5Times) + 1 ;

        refRef.child(refCode).update({
          "users_earned_five" : earning.toString()
        });

        profileRef.child(refereeId).once().then((DataSnapshot snapshot) {
          String mokTokenBal = snapshot.value["mokTokenBalance"];
          double newBal = double.parse(mokTokenBal) + 500;

          profileRef.child(refereeId).update({
            "mokTokenBalance" : newBal.toStringAsFixed(4),
          });
        });
      });
    }
    else if (totalMiningSession == '10') {
      refRef.child(refCode).once().then((DataSnapshot snapshot) {

        String earned10Times = snapshot.value["users_earned_ten"];
        String refereeId = snapshot.value["myUserId"];
        int earning = int.parse(earned10Times) + 1 ;

        refRef.child(refCode).update({
          "users_earned_ten" : earning.toString()
        });

        profileRef.child(refereeId).once().then((DataSnapshot snapshot) {
          String mokTokenBal = snapshot.value["mokTokenBalance"];
          double newBal = double.parse(mokTokenBal) + 1000;

          profileRef.child(refereeId).update({
            "mokTokenBalance" : newBal.toStringAsFixed(4),
          });
        });
      });
    }
  }


  _currentTimeInSeconds() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    String currentTime = (ms / 1000).round().toString();
    setState(() => _currentTime = currentTime);
  }


}
