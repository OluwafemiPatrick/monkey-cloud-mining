import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mcm/home/referral_info_page.dart';
import 'package:mcm/services/auth.dart';
import 'package:mcm/services/firebase_services.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/spinner.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReferralUploadPage extends StatefulWidget {

  final String currentMokEarning;
  ReferralUploadPage(this.currentMokEarning);

  @override
  _ReferralUploadPageState createState() => _ReferralUploadPageState();
}

class _ReferralUploadPageState extends State<ReferralUploadPage> {

  String _fullName='', _fullNameD='full name', _referralCodeD='referral code (optional)',
      _referralCode='', _myReferralCode, _mokEarning='';
  bool _isNameVisible = true;
  bool _isReferralVisible = false;
  bool _isLoading = false;


  @override
  void initState() {
    _getReferralCode();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  _getReferralCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _myReferralCode = prefs.getString("referral_code");
      _mokEarning = widget.currentMokEarning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: AppBar(backgroundColor: colorBgLighter)
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              color: colorBgLighter,
              child: Column(
                  children: [
                    Spacer(flex: 1),
                    Image.asset('assets/icons/logo.png',
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Text('My referral code: $_myReferralCode', style: TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 18.0, color: colorWhite ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(flex: 1,)
                  ])
          ),
          Expanded(
            child: _isLoading ? Spinner() : Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  pageOne(),
                  pageThree(),
                ]),
            ),
          )
        ]),
    );
  }


  Widget pageOne() {
    return Visibility(
      visible: _isNameVisible,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' Kindly tell us your name', style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal
            ),),
            Spacer(flex: 1),
            Container(
              padding: EdgeInsets.only(left:20.0, right: 5.0, top: 15.0, bottom: 0.0),
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: colorGrey1),
              ),
              child: Stack(
                children: [
                  Text(_fullNameD, style: TextStyle(fontSize: 15.0, color: colorBlackLight),),
                  Container(
                    height: 55.0,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      decoration: null,
                      onChanged: (value){
                        setState(() {
                          _fullName = value;
                          _fullNameD = '';
                          if (_fullName.length == 0){
                            _fullNameD = 'full name';
                          }
                        });
                      },
                    ),
                  ),
                ]),
            ),
            SizedBox(height: 50.0,),
            GestureDetector(
              onTap: () {
                if (_fullName.isNotEmpty){
                  setState(() {
                    _isNameVisible = false;
                    _isReferralVisible = true;
                  });
                } else{
                  toastMessage('name cannot be empty');
                }
              },
              child: Container(
                height: 52.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: colorBlue),
                child: Center(
                  child: Text('next', style: TextStyle(
                      color: colorWhite, fontSize: 22.0),
                  ),
                ),
              ),
            ),
            Spacer(flex: 1,),
          ]),
    );
  }
  
  Widget pageThree() {
    return Visibility(
      visible: _isReferralVisible,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(' Enter a referral code to claim bonus', style: TextStyle(
                    fontSize: 17.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal
                ),),
                Spacer(flex: 1,),
                GestureDetector(
                  child: Icon(Icons.info_outline, color: colorBlue, size: 25.0,),
                  onTap: () {
                    Get.to(
                      ReferralInfoPage(),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                )
              ],
            ),
            Spacer(flex: 1),
            Container(
              padding: EdgeInsets.only(left:20.0, right: 5.0, top: 15.0, bottom: 0.0),
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: colorGrey1),
              ),
              child: Stack(
                children: [
                  Text(_referralCodeD, style: TextStyle(fontSize: 16.0, color: colorBlackLight),),
                  Container(
                    height: 55.0,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: null,
                      onChanged: (value){
                        setState(() {
                          _referralCode = value;
                          _referralCodeD = "";
                          if (_referralCode.length == 0){
                            _referralCode = "";
                            _referralCodeD = 'referral code';
                          }
                        });
                      },
                    ),
                  ),
                ],),
            ),
            SizedBox(height: 50.0,),
            uploadButton(),
            Spacer(flex: 1,),
          ]),
    );
  }
  
  Widget uploadButton() {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    return ElevatedButton(
      child: SizedBox(
          height: 52.0,
          width: MediaQuery.of(context).size.width,
          child: Center(child: Text('Submit', style: TextStyle(
              color: colorWhite, fontSize: 20.0))
          )),
      style: ElevatedButton.styleFrom(
        primary: colorBlue,
        onSurface: Colors.grey,
        shadowColor: colorBgMain,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 2,
      ),
      onPressed: () {

        if (_referralCode != _myReferralCode) {
          setState(() => _isLoading = true);
          String email = _firebaseAuth.currentUser.email;
          String userId = _firebaseAuth.currentUser.uid;

          _sendSignUpDataToDB(email, "", _fullName, _myReferralCode, _referralCode, userId);
        }
        else {
          toastError('invalid referral code');
        }

      },
    );
  }


  _sendSignUpDataToDB (String email, password, fullName, referralCode, referredByCode, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseReference refReference = FirebaseDatabase.instance.reference().child("referral_ids");
    FirebaseServices _firebaseServices = new FirebaseServices();

    String referredByUserId;
    String referredByReferralCount;
    String referralChain;
    var newMokEarning = double.parse(_mokEarning) + 200.0000;

    if (referredByCode != ''){
      print ("REFERRAL CODE IS NOT NULL, EXECUTING CODE");
      refReference.child(referredByCode).once().then((DataSnapshot snapshot) {
        referredByUserId = snapshot.value["myUserId"];
        referredByReferralCount = snapshot.value["noOfReferrals"];
        referralChain = snapshot.value["referralChain"];
      }).then((value) {

        int newRefCount = int.parse(referredByReferralCount) + 1;
        _firebaseServices.updateProfileDetailsInDB(fullName, email, password, userId,
            getCurrentDate(), getCurrentTime(), "bnbAddress", newMokEarning.toStringAsFixed(4),
            referralCode, referredByCode, referredByUserId, "0", "0.0000", "0.0000", "0.0000", "0.0000", "1");

        _firebaseServices.uploadChainReferralDetails(referralChain);
        _firebaseServices.uploadReferralDetails(fullName, referralCode, userId, generateNewRefChain(referralChain, referralCode));
        _firebaseServices.updateRefereeReferralCount(referredByCode, newRefCount.toString());
      }).onError((error, stackTrace) {

        print ("REFERRAL CODE IS NULL, UPLOADING PROFILE DETAILS TO DB");
        var newRefCode = '0000-0000-$referralCode';

        _firebaseServices.updateProfileDetailsInDB(fullName, email, password, userId,
            getCurrentDate(), '', "bnbAddress", newMokEarning.toStringAsFixed(4),
            referralCode, "", "", "0", "0.0000", "0.0000", "0.0000", "0.0000", "1");

        _firebaseServices.uploadReferralDetails(fullName, referralCode, userId, newRefCode);
      });
    }

    else {
      print ("REFERRAL CODE IS NULL, UPLOADING PROFILE DETAILS TO DB");
      var newRefCode = '0000-0000-$referralCode';

      _firebaseServices.updateProfileDetailsInDB(fullName, email, password, userId,
          getCurrentDate(), '', "bnbAddress", newMokEarning.toStringAsFixed(4), referralCode,
          "", "", "0", "0.0000", "0.0000", "0.0000", "0.0000", "1");

      _firebaseServices.uploadReferralDetails(fullName, referralCode, userId, newRefCode);
    }

    prefs.setString("currentUser", userId);
    prefs.setString("tokenBalance", newMokEarning.toStringAsFixed(4));
    prefs.setString("totalMiningSessions", "0");
    prefs.setString("totalTokenEarned", "0.0000");
    prefs.setString("referredByCode", referredByCode);
    prefs.setInt("last_login", _getCurrentTime());
    prefs.setString("userEmail", email);
    prefs.setString("isReferralDone", "true");

    Timer(Duration(seconds: 5), () {
      setState(() => _isLoading = false);
      returnToHomePage(context);
    });

  }

  int _getCurrentTime() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    return (ms / 1000).round();
  }

  String generateNewRefChain (String referralChain, myRefCode) {
    var chainSplit = referralChain.split("-");
    String ref1 = chainSplit[1];
    String ref2 = chainSplit[2];

    String newReferralChain = "$ref1-$ref2-$myRefCode";
    return newReferralChain;
  }


}
