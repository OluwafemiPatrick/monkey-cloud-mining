import 'package:flutter/material.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';

class ReferralInfoPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    String _mssg = 'Each user that uses your invitation code to join will receive 200 MOK token as a bonus.'
        '\nCome back when your referral completes 2, 5, and 10 earning sessions to claim your rewards.\n'
        '\nYou earn 20% of your referral daily mining token.';

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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text('Rewards when users earn', style: TextStyle(color: colorGold, fontSize: 15.0)),
                ),
                section1(),
                Spacer(flex: 1),
                section2(),
                Spacer(flex: 1),
              ] ),
        )
    );
  }


  Widget section1() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 30.0),
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Row(
        children: [
          Expanded(child: Container(
            height: 58.0,
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
            height: 58.0,
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
            height: 58.0,
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
              Text('0', style: TextStyle(fontSize: 14.0, color: colorWhite)),
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
              Text('0/0', style: TextStyle(fontSize: 14.0, color: colorWhite)),
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
              Text('0/0', style: TextStyle(fontSize: 14.0, color: colorWhite)),
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
              Text('0/0', style: TextStyle(fontSize: 14.0, color: colorWhite)),
              SizedBox(width: 10.0,),
            ],),
          ),
        ],
      ),
    );
  }


}
