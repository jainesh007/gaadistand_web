
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/registration/select_language.dart';
import 'package:gaadistand/registration/verify_otp.dart';
import 'package:gaadistand/search_taxi/search_screen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController txt_mobile = new TextEditingController(text:'');
  SharedPreferences _sharedPreferences;
  ProgressDialog _progressDialog;
  DateTime currentBackPressTime;
  String deviceId;

  @override
  void initState() {
    super.initState();
    getAllDetails();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Login Screen');
  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));

    deviceId = await AppConstants.getId();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.white,
          child: Stack(

            children: <Widget>[

              ListView(
                children: <Widget>[


                  SizedBox(height: 10.0),

                  Center(
                    child: Container(
                      width: 200,
                      height: 35,
                      child: RaisedButton(
                          color:Color(AppConstants.GRAY_COLOR[4]),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SearchScreen()));
                            },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset('assets/images/search_icon.png')//Icon(Icons.search_outlined, color:Colors.grey,),
                              ),

                              Expanded(
                                flex: 11,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:35.0),
                                  child: Text(AppTranslations.of(context).text("search_taxi"),style: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15)),
                                ),
                              ),


                            ],
                          )),
                    ),
                  ),



                  Container(
                      child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Image.asset('assets/images/otp_verify.png')),height: 250,width: 200,),

                  SizedBox(height: 20.0),

                  Text(AppTranslations.of(context).text("otp_verification"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),

                  SizedBox(height: 10.0),

                  Text(AppTranslations.of(context).text("enter_mobile_number"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 15.0, color: Colors.black)),

                  SizedBox(height: 20.0),

                  Row(
                    children: <Widget>[

                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 49,
                          margin: EdgeInsets.only(left: 20,top: 2),
                          decoration: BoxDecoration(
                              color: Color(AppConstants.GRAY_COLOR[4]),
                              border: Border.all(color: Color(AppConstants.GRAY_COLOR[4]), style: BorderStyle.solid, width: 0.10)),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/india_flag_icon.png'),
                          ),
                        ),
                      ),

                      Expanded(flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(top:9.0,left: 10.0,right: 20.0),
                            child: new TextField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              controller: txt_mobile,
                              maxLength: 10,
                              decoration: new InputDecoration(
                                filled: true,
                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 20),
                                hintText: AppTranslations.of(context).text("mobile_number"), counter: Container(),
                                border: InputBorder.none,
                                fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                                style: TextStyle(fontSize: 20.0, color: Colors.black)
                            ),
                          ),)
                    ],
                  ),

                  SizedBox(height: 10.0),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
                    child: RaisedButton(
                      color:Color(AppConstants.YELLOW_COLOR[0]),
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                      child: Text(AppTranslations.of(context).text("send_otp"), style: TextStyle(color: Colors.black, fontSize: 18)),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(name: 'Otp Send Button Clicked ',parameters:null);

                        if(txt_mobile.text.length!=10 || txt_mobile.text.startsWith(new RegExp(r'[0-5]'))) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("enter_valid_number"));
                        } else {
                          _saveUser(deviceId, txt_mobile.text);
                        }


                      },
                    ),
                  ),

                  SizedBox(height: 50.0),

                  Text(AppTranslations.of(context).text("signing_in"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 12.0, color: Colors.black)),

                  SizedBox(height: 5.0),

                  InkWell(
                    onTap: () async {
                      const url = 'https://gaadistand.com/privacy-policy';
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    },
                      child: Text(AppTranslations.of(context).text("terms_conditions"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 12.0, color: Colors.blue))),
                ],
              ),

              BackButton(color: Colors.black,onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SelectLanguage()));

              },),

            ],
          ),
        )),
      ),
    );
  }

  _saveUser(String device_id, String mobile) async {
    _progressDialog.show();
    print(device_id);
    print(mobile);
    var response = await http.Client().post(AppConstants.SAVE_USER,
        body: {'device_id': device_id , 'mobile': mobile, 'country_code': "+91"},
        headers: {"Accept": "application/json"});

    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.hide();
    if (jsonData['code'] == 200) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OTPVerifyScreen(mobile)));
    } else if (jsonData['code'] == 401) {
      Fluttertoast.showToast(msg: "Session expire, please login again ");
      _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    } else {
      Fluttertoast.showToast(msg: "some error accrued");
    }
  }


  openAlertBox(String message,mobile) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: Text("Otp is : ${message}",textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OTPVerifyScreen(mobile)));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                      child: Text("OKAY!", style: TextStyle(color: Colors.white), textAlign: TextAlign.center)),
                  ),
                ],
              ),
            ),
          );
        });
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

