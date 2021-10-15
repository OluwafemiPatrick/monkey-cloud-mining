import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcm/mcm/home/stake_mok_token_confirmation.dart';
import 'package:mcm/mcm/home/staking_log.dart';
import 'package:mcm/shared/common_methods.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:mcm/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StakeMokToken extends StatefulWidget {
  @override
  _StakeMokTokenState createState() => _StakeMokTokenState();
}

class _StakeMokTokenState extends State<StakeMokToken> {

  String _amountToStake = '', _mokTokenBalance='', _stakedBalance='0.0000';


  @override
  void initState() {
    _fetchUserBalance();
    super.initState();
  }


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
          padding: EdgeInsets.only(bottom: 10.0),
          color: colorBgMain,
          child: ListView(
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                accountBalance(),
                SizedBox(height: 20.0),
                Text('Stake MOK',
                  style: TextStyle(fontSize: 18.0, color: colorGold),
                  textAlign: TextAlign.center,
                ),
                middleContainer(),
                SizedBox(height: 60.0),
                stakeToken(),
              ] ),
        )
    );

  }


  Widget accountBalance() {
    double usdEarning = double.parse(_stakedBalance) * 0.001;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
      padding: EdgeInsets.only(top: 30.0, bottom: 12.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: colorBlue,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                    child: Image.asset('assets/icons/logo.png', height: 50.0, width: 50.0,)
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Total MOK Token Staked', style: TextStyle(fontSize: 13.0, color: colorWhite),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('$_stakedBalance MOK',
                            style: TextStyle(fontSize: 20.0, color: colorWhite)),
                      ),
                      Text('\$ $usdEarning USD', style: TextStyle(fontSize: 12.0, color: colorWhite)),
                    ] ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: null,
                ),
              ] ),
          ]),
    );
  }

  Widget middleContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15.0, bottom: 10.0, left: 4.0, right: 4.0),
      padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: colorBgLighter,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text('Earn up to 36% per year', style: TextStyle(fontSize: 14.0, color: colorWhite),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
            child: Text('Monthly Staking Reward => 3%', style: TextStyle(fontSize: 14.0, color: colorWhite),),
          ),
          GestureDetector(
            child: Container(
              width: 200.0,
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('View Staking History',
                style: TextStyle(fontSize: 15.0, color: colorBlue),
                textAlign: TextAlign.center,),
            ),
            onTap: () {
              Get.to(
                StakingLog(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 500),
              );
            },
          ),
          Container (
            height: 55.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 30.0),
            padding: EdgeInsets.only(top: 3.0),
            decoration: new BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colorGrey1),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'minimum staking 30,000 MOK',
                hintStyle: TextStyle(color: Colors.white60, fontSize: 14.0),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 15.0, color: colorWhite),
              onChanged: (value){
                setState(() {
                  _amountToStake = value;
                });
              },
            ),
          )
        ] ),
    );
  }


  Widget stakeToken() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      height: 50.0,
      child: ElevatedButton(
        child: Text('Stake Token', style: TextStyle(
            color: colorWhite, fontSize: 16.0),),
        style: ElevatedButton.styleFrom(
          primary: colorBlue,
          onSurface: colorGrey2,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
        ),
        onPressed: () {
          var amountToStake = double.parse(_amountToStake);
          var mokBalance = double.parse(_mokTokenBalance);
          if (amountToStake >= 30000) {
            if (mokBalance >= amountToStake) {
              _uploadStakeDetailsToDB();
            } else {
              toastError("insufficient funds");
            }
          } else {
            toastError("minimum staking amount is 30,000 MOK");
          }
        },
      ),
    );
  }


  Future _uploadStakeDetailsToDB() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var ms = (new DateTime.now()).microsecondsSinceEpoch;
    String currentTime = (ms / 1000).round().toString();

    // update details on user account
    var newStakedBalance = double.parse(_stakedBalance) + double.parse(_amountToStake);
    var newAvailableTokenBal = double.parse(_mokTokenBalance) - double.parse(_amountToStake);
    prefs.setString("tokenBalance", newAvailableTokenBal.toStringAsFixed(4));
    profileRef.child("user_profile").child(prefs.getString("currentUser")).update({
      "totalTokenStaked" : newStakedBalance.toStringAsFixed(4),
      "mokTokenBalance" : newAvailableTokenBal.toStringAsFixed(4),
    });

    // send staking details to user profile using timestamp
    profileRef.child("stake_token").child(prefs.getString("currentUser")).child(currentTime).set({
      "amount" : _amountToStake,
      "staked_on" : getCurrentTime(),
    }).then((value) {
      Get.to(
        StakeMokTokenConfirmation(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 400),
      );
    });
  }


  Future _fetchUserBalance() async {
    DatabaseReference profileRef = FirebaseDatabase.instance.reference();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    profileRef.child("user_profile").child(prefs.getString("currentUser")).once().then((DataSnapshot snapshot) {
      setState(() {
        _stakedBalance = snapshot.value["totalTokenStaked"];
        _mokTokenBalance = snapshot.value["mokTokenBalance"];
      });
    });
  }



}
