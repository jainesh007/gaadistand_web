
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/more_item/account_history.dart';
import 'package:gaadistand/more_item/bank_details.dart';
import 'package:gaadistand/more_item/change_language.dart';
import 'package:gaadistand/more_item/invite_friend.dart';
import 'package:gaadistand/more_item/video_player.dart';
import 'package:gaadistand/registration/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoreSectionState();
  }
}

class _MoreSectionState extends State<MoreSection> {

  DateTime currentBackPressTime;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'More Section');
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
        child: WillPopScope(
         onWillPop: onWillPop,
          child: ListView(

            children: <Widget>[

              SizedBox(height: 30.0),

              Center(child: Image.asset('assets/images/more_section_img.png',height: 130, width: 140)),

              SizedBox(height: 20.0),

              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ChangeLanguage()));
                },
                child: Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        color: Color(AppConstants.GRAY_COLOR[4]),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                  child: Row(
                      children: [


                        Expanded(
                            flex: 2,
                            child:Image.asset('assets/images/language.png',height: 30,width: 30)),

                        Expanded(
                            flex: 8,
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppTranslations.of(context).text("change_language"),
                                  style: TextStyle(color: Colors.grey,
                                      fontSize: 16,fontWeight: FontWeight.bold)),
                            )),

                        Expanded(
                            flex: 1,
                            child:Container()),

                        Expanded(
                            flex: 2,
                            child:Icon(Icons.arrow_forward_ios,size: 15,)),

                      ],
                    ),

                ),
              ),

              InkWell(
                onTap: () {
                  launch("https://wa.me/+${919549020777}?text=");

                },
                child: Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        color: Color(AppConstants.GRAY_COLOR[4]),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                    child: Row(
                      children: [


                        Expanded(
                            flex: 2,
                            child:Image.asset('assets/images/support.png',height: 30,width: 30)),

                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppTranslations.of(context).text("support"),
                                  style: TextStyle(color: Colors.grey,
                                      fontSize: 16,fontWeight: FontWeight.bold)),
                            )),

                        Expanded(
                            flex: 1,
                            child:Container()),

                        Expanded(
                            flex: 2,
                            child:Icon(Icons.arrow_forward_ios,size: 15,)),

                      ],
                    ))
              ),

              InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => InviteFriend()));
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                          color: Color(AppConstants.GRAY_COLOR[4]),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                      child: Row(
                        children: [


                          Expanded(
                              flex: 2,
                              child:Image.asset('assets/images/invitation.png',height: 30,width: 30)),

                          Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppTranslations.of(context).text("invite_friend"),
                                    style: TextStyle(color: Colors.grey,
                                        fontSize: 16,fontWeight: FontWeight.bold)),
                              )),

                          Expanded(
                              flex: 1,
                              child:Container()),

                          Expanded(
                              flex: 2,
                              child:Icon(Icons.arrow_forward_ios,size: 15,)),

                        ],
                      ))
              ),

              InkWell(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => BankDetails()));


                },
                child: Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        color: Color(AppConstants.GRAY_COLOR[4]),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                    child: Row(
                      children: [


                        Expanded(
                            flex: 2,
                            child:Image.asset('assets/images/bank.png',height: 30,width: 30)),

                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Bank Details",
                                  style: TextStyle(color: Colors.grey,
                                      fontSize: 16,fontWeight: FontWeight.bold)),
                            )),

                        Expanded(
                            flex: 1,
                            child:Container()),

                        Expanded(
                            flex: 2,
                            child:Icon(Icons.arrow_forward_ios,size: 15,)),

                      ],
                    ))
              ),

              InkWell(
                  onTap: () async {
                    const url = 'https://gaadistand.com/privacy-policy';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }

                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                          color: Color(AppConstants.GRAY_COLOR[4]),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                      child: Row(
                        children: [


                          Expanded(
                              flex: 2,
                              child:Image.asset('assets/images/terms_and_conditions.png',height: 30,width: 30)),

                          Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppTranslations.of(context).text("t_c"),
                                    style: TextStyle(color:Colors.grey,
                                        fontSize: 16,fontWeight: FontWeight.bold)),
                              )),

                          Expanded(
                              flex: 1,
                              child:Container()),

                          Expanded(
                              flex: 2,
                              child:Icon(Icons.arrow_forward_ios,size: 15,)),

                        ],
                      ))

              ),

              InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AccountHistory()));
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                          color: Color(AppConstants.GRAY_COLOR[4]),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                      child: Row(
                        children: [


                          Expanded(
                              flex: 2,
                              child:Image.asset('assets/images/account_history.png',height: 30,width: 30)),

                          Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Account History",
                                    style: TextStyle(color: Colors.grey,
                                        fontSize: 16,fontWeight: FontWeight.bold)),
                              )),

                          Expanded(
                              flex: 1,
                              child:Container()),

                          Expanded(
                              flex: 2,
                              child:Icon(Icons.arrow_forward_ios,size: 15,)),

                        ],
                      ))
              ),

              InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => VideoTutorial()));
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                          color: Color(AppConstants.GRAY_COLOR[4]),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                      child: Row(
                        children: [


                          Expanded(
                              flex: 2,
                              child:Image.asset('assets/images/tutorials.png',height: 30,width: 30)),

                          Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Tutorials",
                                    style: TextStyle(color: Colors.grey,
                                        fontSize: 16,fontWeight: FontWeight.bold)),
                              )),

                          Expanded(
                              flex: 1,
                              child:Container()),

                          Expanded(
                              flex: 2,
                              child:Icon(Icons.arrow_forward_ios,size: 15,)),

                        ],
                      ))
              ),

              InkWell(
                onTap: () async {
                  _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));


                },
                child: Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        color: Color(AppConstants.GRAY_COLOR[4]),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                    child: Row(
                      children: [


                        Expanded(
                            flex: 2,
                            child:Image.asset('assets/images/log_out.png',height: 30,width: 30)),

                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppTranslations.of(context).text("log_out"),
                                  style: TextStyle(color: Colors.grey,
                                      fontSize: 16,fontWeight: FontWeight.bold)),
                            )),

                        Expanded(
                            flex: 1,
                            child:Container()),

                        Expanded(
                            flex: 2,
                            child:Icon(Icons.arrow_forward_ios,size: 15,)),

                      ],
                    ))
              ),



              SizedBox(height: 20.0),

              /*  InkWell(
                  onTap: () async {
                    setState(() {
                      t_c = false;
                      support = false;
                      rewards = false;
                      log_out = false;
                      notification = true;
                      invite_friend = false;
                      change_language = false;
                      bank_details = false;
                    });

                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NotificationList()));

                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                          color: notification == true ? Color(AppConstants.YELLOW_COLOR[1]) :Color(AppConstants.GRAY_COLOR[4]),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                      child: Row(
                        children: [


                          Expanded(
                              flex: 2,
                              child:Image.asset('assets/images/notification.png',height: 30,width: 30)),

                          Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppTranslations.of(context).text("notification"),
                                    style: TextStyle(color: notification == true ? Colors.black :Colors.grey,
                                        fontSize: 16,fontWeight: FontWeight.bold)),
                              )),

                          Expanded(
                              flex: 1,
                              child:Container()),

                          Expanded(
                              flex: 2,
                              child:Icon(Icons.arrow_forward_ios,size: 15,)),

                        ],
                      ))
              ),*/

            ],
          ),
      )),

    );
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
}

