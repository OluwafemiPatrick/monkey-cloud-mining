import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';
import 'package:mcm/shared/toast.dart';
import 'package:share_plus/share_plus.dart';


class InviteAndEarn extends StatefulWidget {

  final String referralCode;
  InviteAndEarn(this.referralCode);

  @override
  _InviteAndEarnState createState() => _InviteAndEarnState();
}

class _InviteAndEarnState extends State<InviteAndEarn> {

  String _referralCode='', _totalInvites='', _subLevelRefCount='', _subLevelRefEarning='';
  String _usersEarned2Times='', _usersEarned5Times='', _usersEarned10Times='';

  @override
  void initState() {
    _getReferralCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String _mssg = 'Each user that uses your invitation code to join will receive 200 MOK token as a bonus. '
        'You also earn MOK tokens for the people that you refer, and for people that your referrals refer (sub-level referrals) up to the 5th sub-level.'
        '\n You earn rewards when your referrals complete 2, 5, and 10 mining sessions .\n';

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
          padding: EdgeInsets.only(bottom: 15.0),
          color: colorBgMain,
          child: ListView(
            children: [
              Divider(color: colorBlue, thickness: 0.5, height: 1.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                child: Text('Invite people and earn extra MOK',
                  style: TextStyle(color: colorGold, fontSize: 15.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                child: Text(_mssg, style: TextStyle(color: colorWhite, fontSize: 14.0),),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('Rewards when users earn', style: TextStyle(color: colorGold, fontSize: 15.0)),
              ),
              section1(),
              section2(),
              SizedBox(height: 40.0),
              section3(),
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 8.0, right: 8.0),
                child: Text('Your Invitation Code', style: TextStyle(color: colorGold, fontSize: 15.0)),
              ),
              bottomButtons(),
          ] ),
        )
    );
  }


  Widget bottomButtons() {
    return Row(
      children: [
        SizedBox(width: 8.0,),
        Expanded(
          child: Container(
            height: 50.0,
            child: ElevatedButton(
              child: Row(
                children: [
                  SizedBox(width: 8.0),
                  Text(_referralCode,
                    style: TextStyle(color: colorWhite, fontSize: 13.0, fontWeight: FontWeight.normal),),
                  Spacer(flex: 1),
                  SizedBox(
                    width: 35.0,
                    child: Icon(Icons.copy, size: 25.0, color: colorWhite))
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: colorBgLighter,
                onSurface: colorGrey2,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 2,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _referralCode));
                toastMessage("code copied to clipboard");
              },
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Container(
            height: 50.0,
            child: ElevatedButton(
              child: Text('Invite', style: TextStyle(
                  color: colorWhite, fontSize: 16.0),),
              style: ElevatedButton.styleFrom(
                primary: colorBlue,
                onSurface: colorGrey2,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 2,
              ),
              onPressed: () {
                Share.share("Hii, kindly sign up on Monkey Cloud Mining using my referral code $_referralCode");
              },
            ),
          ),
        ),
        SizedBox(width: 8.0,),
      ],
    );
  }


  Widget section1() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 40.0),
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Row(
        children: [
          Expanded(child: Container(
            height: 60.0,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: new BoxDecoration(
                color: colorBgLighter,
                borderRadius: BorderRadius.circular(6.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('+ 200 MOK', style: TextStyle(fontSize: 14.0, color: colorGreen),),
                Text('2 Sessions', style: TextStyle(fontSize: 13.0, color: colorGrey1),)
              ],
            ),
          )),
          SizedBox(width: 6.0,),
          Expanded(child: Container(
            height: 60.0,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: new BoxDecoration(
                color: colorBgLighter,
                borderRadius: BorderRadius.circular(6.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('+ 500 MOK', style: TextStyle(fontSize: 14.0, color: colorGreen),),
                Text('5 Sessions', style: TextStyle(fontSize: 13.0, color: colorGrey1),)
              ],
            ),
          )),
          SizedBox(width: 6.0,),
          Expanded(child: Container(
            height: 60.0,
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: new BoxDecoration(
                color: colorBgLighter,
                borderRadius: BorderRadius.circular(6.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('+ 1000 MOK', style: TextStyle(fontSize: 14.0, color: colorGreen),),
                Text('10 Sessions', style: TextStyle(fontSize: 13.0, color: colorGrey1),)
              ],
            ),
          )),
        ],
      ),

    );
  }


  Widget section2() {
    return Container(
      color: colorBgLighter,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text('User Invitation Stats', style: TextStyle(color: colorGold, fontSize: 15.0)),
          ),
          Divider(color: colorGrey1, thickness: 0.5, height: 20.0),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(children: [
              SizedBox(width: 6.0,),
              Expanded(
                child: Text('Total Invited', style: TextStyle(fontSize: 14.0, color: colorWhite),)
              ),
              Text(_totalInvites, style: TextStyle(fontSize: 14.0, color: colorWhite)),
              SizedBox(width: 10.0,),
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(children: [
              SizedBox(width: 6.0,),
              Expanded(
                  child: Text('Users earned 2 Times', style: TextStyle(fontSize: 14.0, color: colorWhite),)
              ),
              Text('$_usersEarned2Times/$_totalInvites', style: TextStyle(fontSize: 14.0, color: colorWhite)),
              SizedBox(width: 10.0,),
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(children: [
              SizedBox(width: 6.0,),
              Expanded(
                  child: Text('Users earned 5 Times', style: TextStyle(fontSize: 14.0, color: colorWhite),)
              ),
              Text('$_usersEarned5Times/$_totalInvites', style: TextStyle(fontSize: 14.0, color: colorWhite)),
              SizedBox(width: 10.0,),
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(children: [
              SizedBox(width: 6.0,),
              Expanded(
                  child: Text('Users earned 10 Times', style: TextStyle(fontSize: 14.0, color: colorWhite),)
              ),
              Text('$_usersEarned10Times/$_totalInvites', style: TextStyle(fontSize: 14.0, color: colorWhite)),
              SizedBox(width: 10.0,),
            ],),
          ),
        ] ),
    );
  }


  Widget section3() {
    return Container(
      color: colorBgLighter,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: Text('Sub-level Referral Earnings', style: TextStyle(color: colorGold, fontSize: 15.0)),
            ),
            Divider(color: colorGrey1, thickness: 0.5, height: 20.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(children: [
                SizedBox(width: 6.0,),
                Expanded(
                    child: Text('Total sub-level referrals', style: TextStyle(fontSize: 14.0, color: colorWhite),)
                ),
                SizedBox(
                  width: 60.0,
                    child: Text('$_subLevelRefCount', style: TextStyle(fontSize: 14.0, color: colorWhite), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(children: [
                SizedBox(width: 6.0,),
                Expanded(
                    child: Text('Total MOK earned from sub-level referrals', style: TextStyle(fontSize: 14.0, color: colorWhite),)
                ),
                SizedBox(
                  width: 80.0,
                  child: Text('$_subLevelRefEarning', style: TextStyle(fontSize: 14.0, color: colorWhite), textAlign: TextAlign.right,)),
                SizedBox(width: 5.0,),
              ],),
            ),
          ] ),
    );
  }


  Future _getReferralCode() async {
    DatabaseReference refReference = FirebaseDatabase.instance.reference().child("referral_ids");

    setState(() {
      _referralCode = widget.referralCode;
    });
    if (_referralCode.isNotEmpty) {
      refReference.child(_referralCode).once().then((DataSnapshot snapshot) {
        setState(() {
          _totalInvites = snapshot.value['noOfReferrals'];
          _usersEarned2Times = snapshot.value['users_earned_two'];
          _usersEarned5Times = snapshot.value['users_earned_five'];
          _usersEarned10Times = snapshot.value['users_earned_ten'];
          _subLevelRefCount = snapshot.value['subLevelRefCount'];
          _subLevelRefEarning = snapshot.value['subLevelRefEarning'];

        });
      });
    }
    else {
      Timer(Duration(seconds: 3), () {
        _getReferralCode();
      });
    }

  }


}
