import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mcm/home/email_verification.dart';
import 'package:mcm/home/referral_info_page.dart';
import 'package:mcm/home/wrapper.dart';
import 'package:mcm/services/auth.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/spinner.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _fullName='', _fullNameD='full name', _email='', _emailD='email address',
      _password='', _confirmPassword='', _referralCodeD='referral code (optional)',
      _referralCode='', _myReferralCode;
  bool _isNameVisible = true;
  bool _isEmailVisible = false;
  bool _isReferralVisible = false;
  bool _isPasswordVisible = false;
  bool _toggleVisibility = true;
  bool _isLoading = false;


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

  void generateReferralCode() async {
    String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnPpQqRrSsTtUuVvWwXxYyZz123456789';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Random _rnd = Random();
    int length = 8;

    String rCode = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)))
    );
    setState(() => _myReferralCode = rCode);
    prefs.setString("referral_code", rCode);
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
                    Text('Welcome to Monkey Cloud Mining', style: TextStyle(
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
                  pageTwo(),
                  pageThree(),
                  pageFour(),
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
                    _isEmailVisible = true;
                    _isReferralVisible = false;
                    _isPasswordVisible = false;
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

  Widget pageTwo() {
    return Visibility(
      visible: _isEmailVisible,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' What is your email address?', style: TextStyle(
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
                  Text(_emailD, style: TextStyle(fontSize: 16.0, color: colorBlackLight),),
                  Container(
                    height: 55.0,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: null,
                      onChanged: (value){
                        setState(() {
                          _email = value;
                          _emailD = "";
                          if (_email.length == 0){
                            _emailD = 'email';
                          }
                        });
                      },
                    ),
                  ),
                ],),
            ),
            SizedBox(height: 50.0,),
            GestureDetector(
              onTap: () {
                if (_email.isNotEmpty){
                  setState(() {
                    _isNameVisible = false;
                    _isEmailVisible = false;
                    _isReferralVisible = true;
                    _isPasswordVisible = false;
                  });
                } else{
                  toastMessage('email address cannot be empty');
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
                Text(' Do you have a referral code?', style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal
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
                            _referralCodeD = 'referral code (optional)';
                          }
                        });
                      },
                    ),
                  ),
                ],),
            ),
            SizedBox(height: 50.0,),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isNameVisible = false;
                  _isEmailVisible = false;
                  _isReferralVisible = false;
                  _isPasswordVisible = true;
                });
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

  Widget pageFour() {
    return Visibility(
      visible: _isPasswordVisible,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(' Create a password', style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal
            ),),
            Spacer(flex: 1),
            Container(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: colorGrey1),
              ),
              child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left:20.0, top: 5.0 ),
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: _toggleVisibility,
                          autofocus: false,
                          decoration: InputDecoration(hintText: "password"),
                          onSaved: (value) => _password = value.trim(),
                          onChanged: (value) {
                            setState(() => _password = value );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 30.0,
                      child: FlatButton(
                        child: Icon(_toggleVisibility==true ? Icons.visibility : Icons.visibility_off, color: colorGrey1),
                        onPressed: () {
                          setState(() => _toggleVisibility = !_toggleVisibility);
                        },
                      ),
                    ),
                    SizedBox(width: 20.0,),
                  ]),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: colorGrey1),
              ),
              child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left:20.0, top: 5.0 ),
                        child: TextFormField(
                          maxLines: 1,
                          obscureText: _toggleVisibility,
                          autofocus: false,
                          decoration: InputDecoration(hintText: "confirm password"),
                          onSaved: (value) => _confirmPassword = value.trim(),
                          onChanged: (value) {
                            setState(() => _confirmPassword = value);
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 30.0,
                      child: FlatButton(
                        child: Icon(_toggleVisibility==true ? Icons.visibility : Icons.visibility_off, color: colorGrey1),
                        onPressed: () {
                          setState(() => _toggleVisibility = !_toggleVisibility);
                        },
                      ),
                    ),
                    SizedBox(width: 20.0,),
                  ]),
            ),
            SizedBox(height: 50.0,),
            signUpButton(),
            SizedBox(height: 10.0,),
            Center(
              child: Text('by signing up, I agree to the privacy policy and terms \nof service of Monkey Cloud Mining',
                style: TextStyle(fontSize: 13.0), textAlign: TextAlign.center,),
            ),
            Spacer(flex: 1,),
          ]),
    );
  }

  Widget signUpButton() {
    final MCMAuthService _auth = MCMAuthService();
    return ElevatedButton(
      child: SizedBox(
          height: 52.0,
          width: MediaQuery.of(context).size.width,
          child: Center(child: Text('Sign up to MCM', style: TextStyle(
              color: colorWhite, fontSize: 20.0))
          )),
      style: ElevatedButton.styleFrom(
        primary: colorBlue,
        onSurface: Colors.grey,
        shadowColor: colorBgMain,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 2,
      ),
      onPressed: () async {
        if (_password.isNotEmpty && _confirmPassword.isNotEmpty){
          if (_password.length > 5){
            if (_password == _confirmPassword){
              setState(() => _isLoading = true);
              dynamic result = await _auth.signUpWithEmailAndPassword(_email, _password, _fullName, _myReferralCode, _referralCode);
              if (result == null){
                setState(() => _isLoading = false);
                toastError('Sign up failed, please try again');
              } else if (result != null){
                Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(
                  builder: (BuildContext context) => EmailVerification(_email),
                ), (route) => false,
                );
              }
            } else {
              toastMessage('passwords do not match');
            }
          } else{
            toastMessage('password cannot be less than 6 characters');
          }
        } else {
          toastMessage('password cannot be empty');
        }
      },
    );
  }


}
