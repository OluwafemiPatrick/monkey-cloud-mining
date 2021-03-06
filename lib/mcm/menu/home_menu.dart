import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcm/home/wrapper.dart';
import 'package:mcm/mcm/home/deposit_mok_token.dart';
import 'package:mcm/mcm/home/invite_and_earn.dart';
import 'package:mcm/mcm/home/stake_mok_token.dart';
import 'package:mcm/mcm/menu/about_mcm.dart';
import 'package:mcm/mcm/menu/calculator.dart';
import 'package:mcm/mcm/menu/faq.dart';
import 'package:mcm/mcm/menu/referral_update.dart';
import 'package:mcm/services/auth.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeMenu extends StatefulWidget {

  final String referralCode, mokEarning;
  HomeMenu(this.referralCode, this.mokEarning);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  final animationDuration = 200;
  final String _urlMCM = 'https://www.monkeycloudmining.com';
  final String twitterUrl = 'https://twitter.com/MonkeyminingMOK?s=09';
  final String telegramUrl = 'https://t.me/Monkeyfinanceofficial';
  final String playStoreLink = 'https://play.google.com/store/apps/details?id=com.monkeycloudmining.app';
  final String appStoreLink = '';
  final String emailAddress = 'support@monkeycloudmining.com';
  final String bscScanUrl = 'https://bscscan.com/address/0x56871514686bdd3627729ed03fcd6da1d1dab1c5';
  String referralCode = '', mokEarning='';


  @override
  void initState() {
    setState(() {
      referralCode = widget.referralCode;
      mokEarning = widget.mokEarning;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBgMain,
      padding: EdgeInsets.only(left: 6.0, right: 4.0),
      child: ListView(
          children: [
            mcmLogo(),
            Divider(color: colorBlue, thickness: 0.5, height: 1.0),
            SizedBox(height: 10.0,),
            depositToken(),
            stakeMokToken(),
            calculator(),
            inviteAndEarn(),
            referralInfo(),
            contactSupport(),
            rateApp(),
            telegram(),
            visitWebsite(),
            twitter(),
            faq(),
            aboutMCM(),
            logOut(),
          ]),
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

  Widget depositToken() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.add, size: 22.0, color: colorGreen,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Deposit MOK Token', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        Get.to(
          DepositMokToken(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: animationDuration),
        );
      } ,
    );
  }

  Widget stakeMokToken() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.gavel, size: 22.0, color: colorRed,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Stake MOK Token', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        Get.to(
          StakeMokToken(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: animationDuration),
        );
      } ,
    );
  }

  Widget inviteAndEarn() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.person_add_alt_outlined, size: 22.0, color: colorRed,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Invite and Earn MOK', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        Get.to(
          InviteAndEarn(referralCode),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: animationDuration),
        );
      } ,
    );
  }

  Widget calculator() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.calculate_outlined, size: 22.0, color: colorGold,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Calculator', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        Get.to(
          MOKTokenCalculator(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: animationDuration),
        );
      } ,
    );
  }

  Widget mokTokenDetails() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.details_outlined, size: 22.0, color: colorGreen,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('MOK Token Details', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        _launchURL(bscScanUrl);
      } ,
    );
  }

  Widget contactSupport() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.contact_support_outlined, size: 22.0, color: colorBlue,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Contact Support', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        launch(_emailLaunchFunction());
      } ,
    );
  }

  Widget rateApp() {
    return GestureDetector(
      child: Platform.isAndroid ? Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.star, size: 22.0, color: colorGold,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Rate on Google Play', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ) : Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.star, size: 22.0, color: colorGold,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Rate on App Store', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        _launchURL(Platform.isAndroid ? playStoreLink : appStoreLink);
      } ,
    );
  }

  Widget visitWebsite() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.public_outlined, size: 22.0, color: colorWhite,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Visit our Website', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        _launchURL(_urlMCM);
      } ,
    );
  }

  Widget faq() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.help_outline, size: 22.0, color: colorPurple,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('FAQ', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        Get.to(
          FAQ(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: animationDuration),
        );
      } ,
    );
  }

  Widget aboutMCM() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.admin_panel_settings_outlined, size: 22.0, color: colorGreen,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('About Monkey Cloud Mining', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        Get.to(
          AboutMCM(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: animationDuration),
        );
      } ,
    );
  }

  Widget logOut() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.logout_outlined, size: 22.0, color: colorRed,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Logout of App', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        logoutDialog(context);
      } ,
    );
  }

  Widget twitter() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Image.asset('assets/images/icon_twitter.png', height: 24.0, width: 24.0,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Visit us on Twitter', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        _launchURL(twitterUrl);
      } ,
    );
  }

  Widget telegram() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                        width: 24.0,
                        child: Image.asset('assets/images/icon_telegram.png', height: 24.0, width: 24.0,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Telegram Channel', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () {
        _launchURL(telegramUrl);
      } ,
    );
  }

  Widget referralInfo() {
    return GestureDetector(
      child: Container(
        height: 45.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    SizedBox(
                      width: 24.0,
                        child: Icon(Icons.room_preferences_outlined, size: 22.0, color: colorPurple,)
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text('Enter referral info', style: TextStyle(
                            fontSize: 15.0, color: colorWhite
                        ),),
                      ),
                    ),
                    SizedBox(
                        width: 24.0,
                        child: Icon(Icons.arrow_forward_ios, size: 18.0, color: colorWhite,)
                    ),
                  ] ),
              Divider(color: colorBlue, height: 0.5,)
            ] ),
      ),
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String _isReferralDone = prefs.getString("isReferralDone");
        if (_isReferralDone == "true") setState(() {
          Get.to(
            ReferralUploadPage(mokEarning),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: animationDuration),
          );
        });
        else {
          toastMessage('you have been referred already');
        }


      } ,
    );
  }


  Future logoutDialog(BuildContext context) async {
    final MCMAuthService _auth = new MCMAuthService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseReference dBRef = FirebaseDatabase.instance.reference().child("user_profile");

    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              color: colorBgLighter,
              padding: const EdgeInsets.all(10.0),
              height: 140.0,
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Text("Logout of Monkey Cloud Monkey?", style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0, color: colorGold),),
                    Spacer(flex: 1,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 32.0,
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: FlatButton(
                              child: Text("No", style: TextStyle(fontSize: 15.0, color: colorWhite),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              color: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Container(
                            height: 32.0,
                            child: FlatButton(
                                child: Text("Yes, logout", style: TextStyle(fontSize: 15.0, color: colorWhite),),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                                color: Colors.transparent,
                                onPressed: () {
                                  Navigator.pop(context);
                                  String userId = prefs.getString('currentUser');
                                  String currentSessionCounterValue = prefs.getInt('counterValue').toString();

                                  // if (currentSessionCounterValue != null) {
                                  //   dBRef.child(userId).update({
                                  //     "currentSessionCounterValue" : currentSessionCounterValue,
                                  //   });
                                  // }
                                  _auth.signOut();

                                }
                            ),
                          ),
                        ]),
                  ]),
            ),
          );
        }
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Future uploadCurrentMiningSessionToDB(String currentSessionCounterValue) async {

    DatabaseReference dBRef = FirebaseDatabase.instance.reference().child("user_profile");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('currentUser');

    dBRef.child(userId).update({
      "currentSessionCounterValue" : currentSessionCounterValue,
    }).then((value) {

    });

  }


  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _emailLaunchFunction () {
    Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Customer Support: Monkey Cloud Mining'
      }),
    );
    return emailLaunchUri.toString();
  }


}
