import 'package:flutter/material.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';

class FAQ extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String questionOne = 'Is MOK token listed on an exchange? What is the value of it?';
    String ansOne = 'MOK token is listed on the PancakeSwap exchange platform. The value is determined by the community and is based on the current trading offering.';
    String questionTwo = 'I have initiated a withdrawal request, for how long do I have to wait?';
    String ansTwo = 'We process withdrawals manually, and depending on the volume of requests that we receive, you may have to wait for up to 24 hours to receive your payment.';
    String questionThree = 'Is there a withdrawal limit?';
    String ansThree = 'Yes, there is a minimum limit. Monkey Cloud Mining covers all transaction charges for withdrawals, therefore it makes sense to process transactions above a certain amount.';
    String questionFour = 'I have a complaint to make or need assistance with some things. How do I go about this?';
    String ansFour = 'Kindly use the Contact Support feature on the previous page. You can also send us an email at support@mcm.com.\nYou will receive an automated response with a ticket number, and a representative of ours will respond to you within 24 hours.';
    String questionFive = 'Can I find Monkey Cloud Mining on social media?';
    String ansFive = 'Yes, you can find us on social media by following the links below';

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
          color: colorBgMain,
          child: Column(
            children: [
              Divider(color: colorBlue, thickness: 0.5, height: 1.0),
              Expanded(
                child: ListView(
                    padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                    children: [
                      SizedBox(height: 20.0,),
                      Text(questionOne, style: TextStyle(fontSize: 16.0, color: colorGold),),
                      SizedBox(height: 15.0,),
                      Text(ansOne, style: TextStyle(fontSize: 14.0, color: colorWhite),),
                      SizedBox(height: 40.0,),
                      Text(questionTwo, style: TextStyle(fontSize: 16.0, color: colorGold),),
                      SizedBox(height: 15.0,),
                      Text(ansTwo, style: TextStyle(fontSize: 14.0, color: colorWhite),),
                      SizedBox(height: 40.0,),
                      Text(questionThree, style: TextStyle(fontSize: 16.0, color: colorGold),),
                      SizedBox(height: 15.0,),
                      Text(ansThree, style: TextStyle(fontSize: 14.0, color: colorWhite),),
                      SizedBox(height: 40.0,),
                      Text(questionFour, style: TextStyle(fontSize: 16.0, color: colorGold),),
                      SizedBox(height: 15.0,),
                      Text(ansFour, style: TextStyle(fontSize: 14.0, color: colorWhite),),
                      SizedBox(height: 40.0,),
                      Text(questionFive, style: TextStyle(fontSize: 16.0, color: colorGold),),
                      SizedBox(height: 15.0,),
                      Text(ansFive, style: TextStyle(fontSize: 14.0, color: colorWhite),),
                      SizedBox(height: 50.0,),
                    ] ),
              ),
            ],
          ),
        )
    );
  }


}
