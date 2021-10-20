import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcm/services/auth.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/spinner.dart';
import 'package:mcm/shared/toast.dart';

import 'wrapper.dart';


class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  String _email='', _password='', _emailD='email', _passwordD='password';
  bool _toggleVisibility = true;
  bool _isLoading = false;

  @override
  void initState() {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Log in with email and password', style: TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal
                  ),),
                  Spacer(flex: 1),
                  emailInput(),
                  passwordInput(),
                  GestureDetector(
                    child: Text(' forgot password?',
                      style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
                    onTap: () {
                      passwordRecoveryPrompt(context);
                    },
                  ),
                  SizedBox(height: 35.0,),
                  loginButton(),
                  Spacer(flex: 1,),
                ]),
            ),
          )
        ]),
    );
  }

  Widget emailInput () {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20.0, top: 15.0),
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: colorGrey1),
      ),
      child: Stack(
          children: [
            Text(_emailD, style: TextStyle(fontSize: 15.0, color: colorBlackLight),),
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
          ] ),
    );
  }


  Widget passwordInput() {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: colorGrey1),
      ),
      child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left:20.0, top: 5.0 ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: Text(_passwordD, style: TextStyle(fontSize: 15.0, color: colorBlackLight),),
                    ),
                    TextFormField(
                      obscureText: _toggleVisibility,
                      autofocus: false,
                      decoration: null,
                      onSaved: (value) => _password = value.trim(),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                          _passwordD = '';
                          if (_password.length == 0){
                            _passwordD = 'password';
                          }
                        });
                      },
                    ),
                  ],
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
    );

  }


  Widget loginButton() {
    final MCMAuthService _auth = MCMAuthService();
    return ElevatedButton(
      child: SizedBox(
          height: 52.0,
          width: MediaQuery.of(context).size.width,
          child: Center(child: Text('Log in to MCM', style: TextStyle(
              color: colorWhite, fontSize: 18.0))
          )),
      style: ElevatedButton.styleFrom(
        primary: colorBlue,
        onSurface: Colors.grey,
        shadowColor: colorBgMain,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 2,
      ),
      onPressed: () async {
        if (_email.isNotEmpty && _password.isNotEmpty){
          setState(() => _isLoading = true);
          dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
          if (result == null){
            setState(() => _isLoading = false);
            toastError('Sign in failed, please try again');
          }
          else if (result != null) {
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                builder: (BuildContext context) => Wrapper(),
              ), (route) => false,
            );
          }

        } else {
          toastMessage('email and password cannot be empty');
        }
      },
    );
  }


  Future passwordRecoveryPrompt(BuildContext context){
    final MCMAuthService _auth = new MCMAuthService();
    String recoveryMail='';
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              color: colorBgLighter,
              padding: const EdgeInsets.all(10.0),
              height: 240.0,
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    Text("Reset your password for Monkey Cloud Mining",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: colorGold),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(flex: 2,),
                    Container(
                      height: 50.0,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                      decoration: new BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: colorBlackLight),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'email address'
                        ),
                        onChanged: (value){
                          setState(() => recoveryMail = value);
                        },
                      ),
                    ),
                    Spacer(flex: 3),
                    Row(
                        children: <Widget>[
                          Spacer(flex: 1,),
                          Container(
                            height: 35.0,
                            width: 80.0,
                            child: TextButton(
                                child: Text("Reset", style: TextStyle(fontSize: 15.0, color: colorGold),),
                                onPressed: () async {
                                  if (recoveryMail.isNotEmpty) {
                                    Navigator.pop(context);
                                    await _auth.forgotPassword(recoveryMail);
                                  } else {
                                    toastError("Kindly enter a valid email");
                                  }
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



}
