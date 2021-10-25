import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mcm/services/auth.dart';
import 'package:mcm/services/firebase_services.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'log_in_page.dart';
import '../mcm/menu/referral_update.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  String _myReferralCode='';
  SharedPreferences prefs;


  @override
  void initState() {
    generateReferralCode();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: AppBar(backgroundColor: colorBgLighter)
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorBgLighter,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  margin: EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/icons/logo.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 00.0),
                  child: Text('Welcome to Monkey Cloud Mining', style: TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 18.0, color: colorBlue ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(flex: 1),
                logInWithEmailAndPassword(),
                SizedBox(height: 20.0,),
                signUpWithGoogle(),
              ],),
          ),
        ),
      ),
    );
  }


  Widget logInWithEmailAndPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text('Log in with Email', style: TextStyle(
                color: colorWhite, fontSize: 15.0),),
            )),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: Colors.grey,
          shadowColor: colorBgMain,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          side: BorderSide(color: colorBlue, width: 1),
          elevation: 2,
        ),
        onPressed: () {
          Get.to(
            LogInPage(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 500),
          );
        },
      ),
    );
  }


  Widget signUpWithGoogle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        child: SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text('Sign up with Google', style: TextStyle(
                color: colorBlue, fontWeight: FontWeight.bold, fontSize: 15.0),),
            )),
        style: ElevatedButton.styleFrom(
          primary: colorWhite,
          onSurface: Colors.grey,
          shadowColor: colorBgMain,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          side: BorderSide(color: colorBlue, width: 1),
          elevation: 2,
        ),
        onPressed: () async {
          prefs = await SharedPreferences.getInstance();
          final MCMAuthService _auth = MCMAuthService();
          await _auth.signInWithGoogle();
          FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

          Timer.periodic(Duration(seconds: 2), (timer) {
            String userId = _firebaseAuth.currentUser.uid;
            String email = _firebaseAuth.currentUser.email;
            var newRefCode = '0000-0000-$_myReferralCode';

            if (userId != null) {
              FirebaseServices firebaseServices = new FirebaseServices();
              firebaseServices.uploadDefaultDetailsToDB('', email, '', userId, getCurrentDate(),
                  getCurrentTime(), '', '100.0000', _myReferralCode, '', '', '0', '0.0000', '0.0000', '0.0000', '0.0000', '1');

              firebaseServices.uploadReferralDetails('', _myReferralCode, userId, newRefCode);

              prefs.setString("currentUser", userId);
              prefs.setString("tokenBalance", "100.0000");
              prefs.setString("totalMiningSessions", "0");
              prefs.setString("totalTokenEarned", "0.0000");
              prefs.setString("referredByCode", '');
              prefs.setInt("last_login", _getCurrentTime());
              prefs.setString("userEmail", email);

              timer.cancel();
            } else {
              toastMessage('processing ...');
            }
          });

        },
      ),
    );
  }


  // Widget signUpWithEmailAndPassword() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 25.0),
  //     child: ElevatedButton(
  //       child: SizedBox(
  //           height: 50.0,
  //           width: MediaQuery.of(context).size.width,
  //           child: Center(child: Text('Sign up with email and password', style: TextStyle(
  //               color: colorWhite, fontWeight: FontWeight.bold, fontSize: 15.0),),
  //           )),
  //       style: ElevatedButton.styleFrom(
  //         primary: colorBlue,
  //         onSurface: Colors.grey,
  //         shadowColor: colorBgMain,
  //         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  //         elevation: 2,
  //       ),
  //       onPressed: () {
  //         Get.to(
  //           ReferralUploadPage(),
  //           transition: Transition.rightToLeft,
  //           duration: Duration(milliseconds: 500),
  //         );
  //       },
  //     ),
  //   );
  //
  // }

  void generateReferralCode() async {
    String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnPpQqRrSsTtUuVvWwXxYyZz123456789';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Random _rnd = Random();
    int length = 12;

    String rCode = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))
    );
    setState(() => _myReferralCode = rCode);
    prefs.setString("referral_code", rCode);
  }

  int _getCurrentTime() {
    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    return (ms / 1000).round();
  }


}
