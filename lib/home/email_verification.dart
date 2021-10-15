// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:mcm/home/wrapper.dart';
// import 'package:mcm/services/auth.dart';
// import 'package:mcm/shared/common_methods.dart';
// import 'package:mcm/shared/constants.dart';
// import 'package:mcm/shared/toast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class EmailVerification extends StatefulWidget {
//
//   final String email;
//   EmailVerification(this.email);
//
//   @override
//   _EmailVerificationState createState() => _EmailVerificationState();
// }
//
// class _EmailVerificationState extends State<EmailVerification> {
//
//   Timer timer;
//   MCMAuthService _mcmAuthService;
//
//   @override
//   void initState() {
//     _sendEmailVerification();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _signOut();
//     super.dispose();
//   }
//
//   _signOut () async {
//     _mcmAuthService = new MCMAuthService();
//     await _mcmAuthService.signOut();
//     print ("Sign OUT METHOD INVOKED");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String email = widget.email;
//
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: Size.fromHeight(1.0),
//           child: AppBar()),
//       body: Container(
//         color: colorBgMain,
//         padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
//         child: Column(
//           children: [
//             Spacer(flex: 1),
//             Image.asset(
//               'assets/icons/logo.png',
//               height: 160.0,
//               width: 160.0,
//             ),
//             Spacer(flex: 1),
//             Text('We sent a confirmation link to $email \nKindly click on the link, then return to this page to continue.',
//               style: TextStyle(fontSize: 15.0, color: colorWhite),
//               textAlign: TextAlign.center,),
//             Spacer(flex: 5),
//             Container(
//               height: 52.0,
//               width: MediaQuery.of(context).size.width * 0.85,
//               child: ElevatedButton(
//                 child: Text('Check Email Verification Status', style: TextStyle(
//                     color: colorWhite, fontSize: 15.0)),
//                 style: ElevatedButton.styleFrom(
//                   primary: colorBlue,
//                   onSurface: Colors.grey,
//                   shadowColor: colorBgLighter,
//                   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
//                   elevation: 2,
//                 ),
//                 onPressed: () {
//                   _checkEmailVerified();
//                 },
//               ),
//             ),
//             Container(
//               height: 50.0,
//               margin: EdgeInsets.only(top: 10.0),
//               child: TextButton(
//                 child: Text('Sign in with a new account'),
//                 onPressed: () async {
//                   _mcmAuthService = new MCMAuthService();
//                   await _mcmAuthService.signOut();
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//                     builder: (BuildContext context) => Wrapper(),
//                   ), (route) => false,
//                   );
//                 },
//               ),
//             )
//           ] ),
//       ),
//     );
//   }
//
//   Future _checkEmailVerified() async {
//     User user = FirebaseAuth.instance.currentUser;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await user.reload();
//
//     if (user.emailVerified) {
//       prefs.setString('isUserEmailVerified', 'true');
//       timer.cancel();
//       toastMessage("email successfully verified");
//       returnToHomePage(context);
//     }
//
//   }
//
//   _sendEmailVerification() async {
//     User user = FirebaseAuth.instance.currentUser;
//     if (user!= null && !user.emailVerified) {
//       await user.sendEmailVerification();
//     }
//
//     timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       _checkEmailVerified();
//     });
//   }
//
//
// }
