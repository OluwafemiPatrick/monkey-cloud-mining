import 'package:flutter/material.dart';
import 'package:mcm/shared/constants.dart';
import 'package:mcm/shared/mcm_logo.dart';

class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {

  final PageController _pageController = PageController(initialPage: 0);

  final int _numPages = 4;
  int _currentPage = 0;


  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 10.0,
      width:  20.0,
      decoration: BoxDecoration(
          color: isActive ? colorGold : colorBgLighter,
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(color: colorBlue, thickness: 0.5, height: 1.0),
                Expanded(
                  child: PageView(
                    allowImplicitScrolling: true,
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                      onPageChanged: (int page) {
                      setState(() => _currentPage = page);
                      },
                    children: [
                      Container(
                        color: colorRed,
                      ),
                      Container(
                        color: colorBlack,
                      ),
                      Container(
                        color: colorBlue,
                      ),
                      Container(
                        color: colorPurple,
                      ),
                    ],
                  )
                ),
                SizedBox(height: 8.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ] ),
        )
    );
  }
}
