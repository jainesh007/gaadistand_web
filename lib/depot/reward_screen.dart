
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/depot/radio_button_pop_up.dart';
import 'package:gaadistand/depot/reward_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RewardSectionState();
  }
}

class _RewardSectionState extends State<RewardSection> {

  SharedPreferences _sharedPreferences;

  double percent = 0;
  bool showFront = true;
  DateTime currentBackPressTime;


  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Reward Section');
    getAllDetails();


    Future.delayed(Duration(microseconds: 500), () {
     setState(() {
       percent = 60;
     });
    });
  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: AppTranslations.of(context).text("back_press"));
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(

      body: SafeArea(

        child: WillPopScope(
        onWillPop: onWillPop,

           child: ListView(
            children: <Widget>[

            SizedBox(height: 10),



            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Depot", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold))),

            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("EARN GAADISTAND REWARDS", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),

            SizedBox(height: 10),


            Padding(
              padding: const EdgeInsets.only(left:30.0,right: 30,top: 10),
              child: RoundedProgressBar(
                milliseconds: 1000,
                height: 40,
                style: RoundedProgressBarStyle(
                    colorBackgroundIcon:  Color(AppConstants.YELLOW_COLOR[0]),
                    colorProgress: Color(AppConstants.YELLOW_COLOR[0]),
                    colorProgressDark: Color(AppConstants.YELLOW_COLOR[0]),
                    colorBorder: Colors.transparent,
                    backgroundProgress: Colors.blueGrey[100],
                    borderWidth: 5, widthShadow: 6),
                margin: EdgeInsets.symmetric(vertical: 8),
                percent: 60,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text("0", textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold)),
                ),


                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text("1000", textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold)),
                ),


              ],
            ),

            SizedBox(height: 50),

            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "1 point = 10 Paisa ",style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0,color: Colors.black)),
                    WidgetSpan(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardInformation()));
                          },
                          child: Icon(Icons.info, size: 21)),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20,top: 20),
              child: Text("Your Life Time Balance is 1000", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),

            Container(
              padding: EdgeInsets.all(15.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Column(
                   children: [

                     Image.asset('assets/images/invitation_one.png',height: 30,width: 30),

                     SizedBox(height: 10),

                     Text("Invite", style: TextStyle(color:Colors.black, fontSize: 12,fontWeight: FontWeight.bold))

                   ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),

                  Column(
                    children: [

                      Image.asset('assets/images/whatsapp.png',height: 30,width: 30),

                      SizedBox(height: 10),

                      Text("Whatsapp", style: TextStyle(color:Colors.black, fontSize: 12,fontWeight: FontWeight.bold))

                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),

                  Column(
                    children: [

                      Image.asset('assets/images/post.png',height: 30,width: 30),

                      SizedBox(height: 10),

                      Text("Post", style: TextStyle(color:Colors.black, fontSize: 12,fontWeight: FontWeight.bold))

                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),

                  Column(
                    children: [

                      Image.asset('assets/images/contact.png',height: 30,width: 30),

                      SizedBox(height: 10),

                      Text("Contacted", style: TextStyle(color:Colors.black, fontSize: 12,fontWeight: FontWeight.bold))

                    ],
                  ),

                ],
              ),
            ),


            SizedBox(height: 40),


            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 12, right: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
              child: RaisedButton(
                color:Color(AppConstants.YELLOW_COLOR[0]),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                child: Text("REDEEM 1000 Points", style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
                onPressed: () {
                  FirebaseAnalytics().logEvent(name: 'Redeem Button Clicked',parameters:null);

                  _settingModalBottomSheet();

                })
              ),


            Padding(
              padding: const EdgeInsets.only(bottom: 20,top: 15),
              child: Text("Start redeeming your points once you cover 250 points.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),

          ],
        ),
      )),
    );
  }




  void _settingModalBottomSheet(){

    showModalBottomSheet<dynamic>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RedeemRadioButton(),
    );
  }
}