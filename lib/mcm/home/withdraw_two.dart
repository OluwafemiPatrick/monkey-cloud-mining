import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcm/mcm/home/withdraw_token_three.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WithdrawTokenTwo extends StatelessWidget {

  final String amount, address;

  WithdrawTokenTwo(this.amount, this.address);

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(bottom: 20.0),
          color: colorBgMain,
          child: Column(
            children: [
              Divider(color: colorBlue, thickness: 0.5, height: 1.0),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text('Confirm Transaction', style: TextStyle(
                  fontSize: 18.0, color: colorWhite, fontWeight: FontWeight.bold
                ),),
              ),
              Spacer(flex: 1),
              _middleBody(context),
              Spacer(flex: 4),
              _withdrawButton(context),
            ],
          ),
        )
    );
  }


  Widget _middleBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: colorGrey1, thickness: 0.1, height: 0.1),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5.0, right: 5.0, left: 12.0),
            child: Text('Amount', style: TextStyle(fontSize: 15.0, color: colorWhite),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 5.0, left: 12.0),
            child: Text('$amount MOK',
              style: TextStyle(fontSize: 13.0, color: colorGrey1),),
          ),
          Divider(color: colorGrey1, thickness: 0.2, height: 0.2),

          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 5.0, right: 5.0, left: 12.0),
            child: Text('From', style: TextStyle(fontSize: 15.0, color: colorWhite),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 5.0, left: 12.0),
            child: Text('Monkey Cloud Mining ($MY_BNB_ADDRESS)',
              style: TextStyle(fontSize: 13.0, color: colorGrey1),),
          ),
          Divider(color: colorGrey1, thickness: 0.2, height: 0.2),

          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 5.0, right: 5.0, left: 12.0),
            child: Text('To', style: TextStyle(fontSize: 15.0, color: colorWhite),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 5.0, left: 12.0),
            child: Text(address,
              style: TextStyle(fontSize: 13.0, color: colorGrey1),),
          ),
          Divider(color: colorGrey1, thickness: 0.2, height: 0.2),

        ] ),
    );
  }

  Widget _withdrawButton(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        child: Text('Confirm', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          _initiateWithdrawal();
        },
      ),
    );
  }

  Future _initiateWithdrawal() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    String currentTime = (ms / 1000).round().toString();
    var availableTokenBalance;
    var totalTokenWithdrawn;
    

    // update details on user account
    profileRef.child("user_profile").child(prefs.getString("currentUser")).once().then((DataSnapshot snapshot) {
      totalTokenWithdrawn = snapshot.value["totalTokenWithdrawn"];
      availableTokenBalance = snapshot.value["mokTokenBalance"];
    }).then((value) {
      var newTotalTokenWithdrawn = double.parse(totalTokenWithdrawn) + double.parse(amount);
      var newAvailableTokenBal = double.parse(availableTokenBalance) - double.parse(amount);
      prefs.setString("tokenBalance", newAvailableTokenBal.toStringAsFixed(4));
      profileRef.child("user_profile").child(prefs.getString("currentUser")).update({
        "totalTokenWithdrawn" : newTotalTokenWithdrawn.toStringAsFixed(4),
        "mokTokenBalance" : newAvailableTokenBal.toStringAsFixed(4),
      });
      print ("ACCOUNT DETAILS UPDATED SUCCESSFULLY");
    });


    // send withdrawal_log info to database
    profileRef.child("withdrawal").child(prefs.getString("currentUser")).child(currentTime).set({
      "amount" : amount,
      "time" : getCurrentTime(),
      "address" : address,
      "isDisbursed" : "false",
      "status" : "Withdrawal",
    }).then((value) {
      Get.to(
        WithdrawTokenConfirmation(amount, address),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 400),
      );
    });

  }



}
