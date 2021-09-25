
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcm/mcm/home/invite_and_earn.dart';
import 'package:mcm/mcm/home/mok_token_earning.dart';
import 'package:mcm/mcm/home/mok_token_earning.dart';
import 'package:mcm/mcm/home/stake_mok_token.dart';
import 'package:mcm/mcm/home/withdraw_token.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'deposit_mok_token.dart';


class HomeHome extends StatefulWidget {
  @override
  _HomeHomeState createState() => _HomeHomeState();
}

class _HomeHomeState extends State<HomeHome> {

  SharedPreferences prefs;
  String _currentTime, _mokTokenBalance="0.0000";
  String _hour='', _min='';
  int _pageTransition = 200;

  @override
  void initState() {
    _getMokBalance();
    _pushLastMiningDetailsToDB();
    myBanner.load();
    super.initState();
  }


  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }


  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
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
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      color: colorBgMain,
      child: Column(
          children: [
            mcmLogo(),
            Divider(color: colorBlue, thickness: 0.5, height: 1.0),
            accountBalance(),
            Spacer(flex: 1),
            buttonDisplay(),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: adWidget,
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
              ),
            ),
            startMining(),
          ] ),
    );
  }


  Widget mcmLogo(){
    return  Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      color: colorBgLighter,
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Image.asset("assets/icons/logo.png"),
    );
  }

  Widget buttonDisplay() {
    return Container(
      height: 150.0,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Expanded(
              child: Container(
                height: 45.0,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.api_outlined, size: 18.0, color: colorWhite),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text('Deposit MOK token', style: TextStyle(
                            color: colorWhite, fontSize: 13.0),),
                      ),
                    ],),
                  style: ElevatedButton.styleFrom(
                    primary: colorBgLighter,
                    onSurface: colorBlue,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Get.to(
                      DepositMokToken(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: _pageTransition),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10.0,),
            Expanded(
              child: Container(
                height: 45.0,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.gavel_outlined, size: 18.0, color: colorWhite),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Text('Stake MOK token', style: TextStyle(
                            color: colorWhite, fontSize: 13.0),),
                      ),
                    ],),
                  style: ElevatedButton.styleFrom(
                    primary: colorBgLighter,
                    onSurface: colorBlue,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Get.to(
                      StakeMokToken(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: _pageTransition),
                    );
                  },
                ),
              ),
            )
          ]),
          Row(children: [
            Expanded(
              child: Container(
                height: 45.0,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.insert_invitation_outlined, size: 18.0, color: colorWhite),
                      SizedBox(width: 6.0),
                      Text('Invite & Earn', style: TextStyle(
                          color: colorWhite, fontSize: 13.0),),
                    ],),
                  style: ElevatedButton.styleFrom(
                    primary: colorBgLighter,
                    onSurface: colorBlue,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Get.to(
                      InviteAndEarn(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: _pageTransition),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10.0,),
            Expanded(
              child: Container(
                height: 45.0,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.open_with_outlined, size: 18.0, color: colorWhite),
                      SizedBox(width: 6.0),
                      Text('Withdraw token', style: TextStyle(
                          color: colorWhite, fontSize: 13.0),),
                    ],),
                  style: ElevatedButton.styleFrom(
                    primary: colorBgLighter,
                    onSurface: colorBlue,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Get.to(
                      WithdrawToken(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: _pageTransition),
                    );
                  },
                ),
              ),
            )
          ]),
          Row(children: [
            Expanded(
              child: Container(
                height: 45.0,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.fact_check_outlined, size: 18.0, color: colorWhite),
                      SizedBox(width: 6.0),
                      Text('Daily Check-in', style: TextStyle(
                          color: colorWhite, fontSize: 13.0),),
                    ],),
                  style: ElevatedButton.styleFrom(
                    primary: colorBgLighter,
                    onSurface: colorBlue,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 2,
                  ),
                  onPressed: () {
                    _dailyRewardUpdate();
                  },
                ),
              ),
            ),
            SizedBox(width: 10.0,),
            Expanded(
              child: Container(
                height: 45.0,
                child: null,
              ),
            )
          ]),
        ]),
    );
  }


  Widget accountBalance() {
    _getMokBalance();

    double usdEarning = double.parse(_mokTokenBalance) * 0.001;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
      padding: EdgeInsets.only(top: 10.0, bottom: 6.0),
      height: 120.0,
      decoration: new BoxDecoration(
        color: colorBlue,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: [
          Text('MOK Token Balance', style: TextStyle(fontSize: 13.0, color: colorWhite),),
          Container(
            height: 60.0,
            child: Row(
              children: [
                Expanded(child: SizedBox(
                  height: 50.0,
                    width: 50.0,
                    child: Image.asset('assets/icons/logo.png'))),
                Expanded(child: Text(_mokTokenBalance,
                  style: TextStyle(fontSize: 24.0, color: colorWhite),
                  textAlign: TextAlign.center,
                )),
                Expanded(child: Container(child: null,))
              ] )
          ),
          Text('\$' + usdEarning.toStringAsFixed(4) +' USD',
            style: TextStyle(fontSize: 12.0, color: colorWhite),),
        ] ),

    );
  }

  Widget startMining() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50.0,
      child: ElevatedButton(
        child: Text('Start Mining', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          Get.to(
            MokTokenEarning(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: _pageTransition),
          );
        },
      ),
    );
  }

  _pushLastMiningDetailsToDB() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();
    prefs = await SharedPreferences.getInstance();
    var localTotalMiningSession = prefs.getString("totalMiningSessions");
    var miningSessionFromDB;

    profileRef.child("user_profile").child(prefs.getString("currentUser")).once().then((DataSnapshot snapshot) {
      miningSessionFromDB = snapshot.value["totalMiningSessions"];
      int diff = int.parse(localTotalMiningSession) - int.parse(miningSessionFromDB);
      print ("MINING SESSION FETCHED. Difference is : " + diff.toString() );
    }).then((value) {
      var localSession = double.parse(localTotalMiningSession);
      var onlineSession = double.parse(miningSessionFromDB);

      if (localSession > onlineSession) {
        _updateMiningDataToDB();
      }
    });

  }

  _updateMiningDataToDB() {
    _currentTimeInSeconds();
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();

    String totalBal = prefs.getString("tokenBalance");
    String numOfSessions = prefs.getString("totalMiningSessions");
    String totalTokenEarned = prefs.getString("totalTokenEarned");

    var totalTokenMined;
    var availableTokenBalance;

    profileRef.child("user_profile").child(prefs.getString("currentUser")).update({
      "mokTokenBalance" : totalBal,
      "totalMiningSessions" : numOfSessions,
      "totalTokenEarned" : totalTokenEarned,
    });

    _sendReferralBonus(numOfSessions);

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

  _currentTimeInSeconds() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    String currentTime = (ms / 1000).round().toString();
    setState(() => _currentTime = currentTime);
  }

  _getMokBalance() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    prefs = await SharedPreferences.getInstance();
    var tokBal = prefs.getString("tokenBalance");

    if (tokBal != null) {
      setState(() => _mokTokenBalance = tokBal);
    }
    else {
      profileRef.child(prefs.getString("currentUser")).once().then((DataSnapshot snapshot) {
        setState(() {
          _mokTokenBalance = snapshot.value["mokTokenBalance"];
          prefs.setString("tokenBalance", snapshot.value["mokTokenBalance"]);
        });
      });
    }

    print ("MOK TOKEN BALANCE IS $_mokTokenBalance");
  }

  _dailyRewardUpdate() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    prefs = await SharedPreferences.getInstance();
    var ms = (new DateTime.now()).microsecondsSinceEpoch;

    int time24 = 86400000;
    //int time24 = 5000;

    int currentTime = (ms / 1000).round();
    int lastLogin = prefs.getInt("last_login");
    int timeBetweenLogin = currentTime - lastLogin;
    double timeLeft = (time24-timeBetweenLogin) / 1000;

    String dayCount;
    _calculateTimestamp(timeLeft);

    profileRef.child(prefs.getString("currentUser")).once().then((DataSnapshot snapshot) {
      dayCount = snapshot.value["dayCount"];
    }).then((value) {
      int dailyCount = int.parse(dayCount);

      if (timeBetweenLogin > time24) {
        if (timeBetweenLogin < (time24 * 2)) {
          int newCount = dailyCount + 1;
          if (newCount < 7) {
            // add 100 MOK
            _dailyCheckIn(context, true, newCount, 100.0000);
            prefs.setInt("last_login", currentTime);
            print ('METHOD ONE 1 CALLED');
          }
          if (newCount>6 && newCount<14) {
            // add 200 MOK
            _dailyCheckIn(context, true, newCount, 200.0000);
            prefs.setInt("last_login", currentTime);
            print ('METHOD TWO 2 CALLED');
          }
          if (newCount>13 && newCount<21) {
            // add 300 MOK
            _dailyCheckIn(context, true, newCount, 300.0000);
            prefs.setInt("last_login", currentTime);
            print ('METHOD THREE 3 CALLED');
          }
          if (newCount>20 && newCount<30) {
            // add 400 MOK
            _dailyCheckIn(context, true, newCount, 400.0000);
            prefs.setInt("last_login", currentTime);
            print ('METHOD FOUR 4 CALLED');
          }
          if (newCount == 30) {
            // add 500 MOK
            _dailyCheckIn(context, true, newCount, 500.0000);
            prefs.setInt("last_login", currentTime);
            print ('METHOD FIVE 5 CALLED');
          }
          if (newCount > 30) {
            // reset daily_count
            _dailyCheckIn(context, true, 1, 100.00000);
            prefs.setInt("last_login", currentTime);
            print ('METHOD SIX 6 CALLED');
          }
        }
        else {
          // reset daily_counter and add 100 MOK
          _dailyCheckIn(context, true, 1, 100.0000);
          prefs.setInt("last_login", currentTime);
          print ('METHOD SEVEN 7 CALLED');
        }
      }
      else {
        // add 0 MOK
        _dailyCheckIn(context, false, dailyCount, 0.0000);
        print ('METHOD EIGHT 8 CALLED');
      }
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

  Future _dailyCheckIn(BuildContext context, bool isCheckValid, int dayCount, double mokAmount){
    _sendCheckInRewardToDB(mokAmount, dayCount);
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              color: colorBgLighter,
              padding: const EdgeInsets.all(10.0),
              height: 180.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    isCheckValid ? _validDisplayCon(dayCount, mokAmount.toStringAsFixed(0)) : _invalidDisplayCon(),
                    Spacer(flex: 1),
                    Row(
                      children: [
                        Spacer(flex: 1),
                        Container(
                          height: 32.0,
                          width: 120.0,
                          child: FlatButton(
                              child: Text("Dismiss", style: TextStyle(fontSize: 14.0, color: colorGold),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              color: Colors.transparent,
                              onPressed: () {
                                Navigator.of(context).pop();
                                initState();
                              }
                          ),
                        ),
                      ],),
                  ]),
            ),
          );
        }
    );
  }

  _validDisplayCon(int dayCount, String mokAmount) {
    String _mssg = 'Congrats! You have earned $mokAmount MOK for checking in today. Come back tomorrow for more';
    return Column(
      children: [
        Text('Day $dayCount reward', style: TextStyle(fontSize: 16.0, color: colorGold, fontWeight: FontWeight.bold),),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
          child: Text(_mssg, style: TextStyle(fontSize: 13.0, color: colorWhite), textAlign: TextAlign.center,),
        )
      ],
    );
  }

  _invalidDisplayCon() {
    String _mssg = 'You have claimed today\'s reward.\nCome back in $_hour hr $_min min to earn more.';
    return Column(
      children: [
        Text('Oops!', style: TextStyle(fontSize: 16.0, color: colorGold, fontWeight: FontWeight.bold),),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
          child: Text(_mssg, style: TextStyle(fontSize: 13.0, color: colorWhite), textAlign: TextAlign.center,),
        )
      ]);
  }

  _sendCheckInRewardToDB(double amount, int dayCount) async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference().child("user_profile");
    prefs = await SharedPreferences.getInstance();

    double newMokTokenBalance = double.parse(_mokTokenBalance) + amount;
    print ('MY NEW TOKEN BALANCE IS : $newMokTokenBalance');
    prefs.setString("tokenBalance", newMokTokenBalance.toStringAsFixed(4));

    profileRef.child(prefs.getString("currentUser")).update({
      "mokTokenBalance" : newMokTokenBalance.toStringAsFixed(4),
      "dayCount" : dayCount.toString(),
    });
  }

  _calculateTimestamp(double timestamp) {
    var hourLeft = (timestamp ~/ 3600).toString();

    if (int.parse(hourLeft) > 0) {
      var hourInSeconds = int.parse(hourLeft) * 3600;
      var minutesLeft = ((timestamp-hourInSeconds) ~/ 60).toString();
      setState(() {
        _hour = hourLeft;
        _min = minutesLeft;
      });
    }
    else {
      var minutesLeft = (timestamp ~/ 60).toString();
      setState(() {
        _hour = hourLeft;
        _min = minutesLeft;
      });
    }
  }


}
