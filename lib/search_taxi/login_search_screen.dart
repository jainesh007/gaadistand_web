
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/search_taxi/search_verify_otp.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/appcontants.dart';

class SearchLoginScreen extends StatefulWidget {
  @override
  _SearchLoginScreenState createState() => new _SearchLoginScreenState();
}

class _SearchLoginScreenState extends State<SearchLoginScreen> {

  TextEditingController txt_mobile = new TextEditingController(text:'');
  SharedPreferences _sharedPreferences;
  String deviceId;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    getAllDetails();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Search Login Screen');
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
        child: Container(
          color: Colors.white,
          child: Stack(

            children: <Widget>[

              ListView(
                children: <Widget>[


                  SizedBox(height: 10.0),


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
                              color: Color(AppConstants.GRAY_COLOR[0]),
                              border: Border.all(color: Color(AppConstants.GRAY_COLOR[0]), style: BorderStyle.solid, width: 0.10)),

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
                                fillColor: Color(AppConstants.GRAY_COLOR[0]),),
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

                  Text(AppTranslations.of(context).text("terms_conditions"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 12.0, color: Colors.blue)),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }


  _saveUser(String device_id,String mobile) async {
    _progressDialog.show();
    print(device_id);
    print(mobile);
    print(AppConstants.SAVE_USER);
    var response = await http.Client().post(AppConstants.SAVE_USER,
        body: {'device_id': device_id , 'mobile': mobile, 'country_code': "+91"},
        headers: {"Accept": "application/json"});

    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.hide();
    if (jsonData['code'] == 200) {

      var otp_code = jsonData['otp_code'];
      print(otp_code);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SearchOTPVerifyScreen(mobile)));

    } else {
      Fluttertoast.showToast(msg: "some error accrued");
    }

  }
}

