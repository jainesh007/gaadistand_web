
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RewardInformationState();
  }
}

class _RewardInformationState extends State<RewardInformation> {

  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Reward information');
    getAllDetails();
  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }





  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(

      body: SafeArea(

        child: ListView(
          children: <Widget>[

            SizedBox(height: 10),

            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child:  Image.asset('assets/images/cancel.png',height: 35,width: 35)),
              ),
            ),


            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("EARN GAADISTAND REWARDS", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: const EdgeInsets.all(6),
              child: Text("1 point = 10 paisa", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("1 GaadiStand Point Reward is equals to 10 paisa.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
              child: Text("Example: On inviting your friend you will get 50 points which in turn equals to 500 Paisa (5 INR)", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),


            Text("Total Points Earned", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),

            Padding(
              padding: const EdgeInsets.only(left:10,right: 10,top: 5),
              child: Text("Total points earned by you so far.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("Invite Friends", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),


            Padding(
              padding: const EdgeInsets.only(left:10,right: 10,top: 5),
              child: Text("Now, earn 50 points by simply inviting your friend. Share your invite code with your friends, and you will earn Gaadistand Points once they join the app with your code.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("Search Taxi's", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),


            Padding(
              padding: const EdgeInsets.only(left:10,right: 10,top: 5),
              child: Text("Earn 10 points on each search.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("Create Post", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),


            Padding(
              padding: const EdgeInsets.only(left:10,right: 10,top: 5),
              child: Text("Earn 10 points on posting your vehicle availability.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("Redeem Rewards", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),


            Padding(
              padding: const EdgeInsets.only(left:10,right: 10,top: 5),
              child: Text("Just tap over the Redeem button to redeem the points into your bank accout. You will only be able to Redeem once you hit the minimum qualifcation points - 250", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),


            SizedBox(height: 50),

          ],
        ),
      ),
    );
  }
}

