import 'package:flutter/material.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';

class AboutMCM extends StatelessWidget {

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
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          color: colorBgMain,
          child: Column(
            children: [
              Divider(color: colorBlue, thickness: 0.5, height: 1.0),
              Spacer(flex: 1,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Image.asset('assets/icons/logo.png')
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 25.0),
                child: Text('Monkey Cloud Mining', style: TextStyle(fontSize: 24.0, color: colorGold),),
              ),
              Text('Version: $VERSION_NUMBER', style: TextStyle(fontSize: 14.0, color: colorWhite),),
              SizedBox(height: 10.0,),
              Text('Copyright @ Monkey Cloud Mining 2021', style: TextStyle(fontSize: 14.0, color: colorWhite),),
              SizedBox(height: 10.0,),
              Text('All rights reserved.', style: TextStyle(fontSize: 14.0, color: colorWhite),),

              Spacer(flex: 2,),


            ],
          ),
        )
    );
  }
}
