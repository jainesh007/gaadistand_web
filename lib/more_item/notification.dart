
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationListState();
  }
}

class _NotificationListState extends State<NotificationList> {

  SharedPreferences _sharedPreferences;

  List<String> notification_list =  List<String>();
  ProgressDialog _progressDialog;


  @override
  void initState() {
    super.initState();

    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));

    FirebaseAnalytics().setCurrentScreen(screenName: 'Notification List');


    notification_list.add("a");
    notification_list.add("a");
    notification_list.add("a");
    notification_list.add("a");
    notification_list.add("a");

  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(

      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackButton(color: Colors.black),
              ),

              SizedBox(height: 10),

              notification_list.length == 0 ?

              Container(

                  child: Column(

                    children: <Widget>[

                      SizedBox(height: 50),

                      Center(child: Image.asset('assets/images/notification.png',height: 150,width: 150,)),

                      SizedBox(height: 30.0),

                  Text("No Notification found", style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold))

                    ],
                  )) :

              Flexible(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: notification_list.length,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left:15,right: 15, bottom: 5,top: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color:Color(AppConstants.GRAY_COLOR[4]),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Stack(

                                children: [

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                          child: Text("Congrats!", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)))),


                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text("04/01/2021", style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold)))),

                                ],
                              ),

                              SizedBox(height: 10),

                              Text("You have received 40 points.", style: TextStyle(color: Colors.grey, fontSize: 16))

                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )),

    );
  }



}
