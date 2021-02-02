
import 'dart:convert';


import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/home_page.dart';
import 'package:gaadistand/registration/login_screen.dart';
import 'package:gaadistand/registration/main_home_page.dart';
import 'package:gaadistand/registration/pin_code_fields.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerifyScreen extends StatefulWidget {

  String mobile_number;

  OTPVerifyScreen(this.mobile_number);
  @override
  _OTPVerifyScreenState createState() => new _OTPVerifyScreenState(mobile_number);

}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {

  String mobile_number;
  String currentText;

  _OTPVerifyScreenState(this.mobile_number);

  TextEditingController txt_mobile = new TextEditingController(text:'');
  SharedPreferences _sharedPreferences;

  String deviceId;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    getAllDetails();
    FirebaseAnalytics().setCurrentScreen(screenName: 'OTP Verify Screen');
    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));

  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
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

                  SizedBox(height: 100.0),

                  Container(
                      child:Image.asset('assets/images/otp_verify_screen.png', height: 160, width: 170,)),

                  SizedBox(height: 20.0),

                  Text(AppTranslations.of(context).text("otp_verification"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),

                  SizedBox(height: 10.0),

                  Text(AppTranslations.of(context).text("otp_code"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 15.0, color: Colors.black)),

                  SizedBox(height: 20.0),

                  Column(
                    children: [
                      Container(
                        width: 250,
                        child: PinCodeTextFieldOlder(
                          length: 4,
                          obsecureText: false,
                          animationType: AnimationType.fade,
                          shape: PinCodeFieldShape.box,
                          animationDuration: Duration(milliseconds: 100),
                          borderRadius: BorderRadius.circular(0),
                          fieldHeight: 50,
                          backgroundColor: Colors.white,
                          fieldWidth: 50,
                          currentText: (value) {
                            print(value);
                            setState(() {
                               currentText = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.0),

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
                      child: Text(AppTranslations.of(context).text("verify_otp"), style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(name: 'Otp Verify Button Clicked ',parameters:null);
                        // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MainHomePage()));

                        _verifyOTP(deviceId, mobile_number, currentText);
                      },
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: () {
                                  FirebaseAnalytics().logEvent(name: 'Edit Number Button Clicked ',parameters:null);
                                  Navigator.pop(context);
                                },
                                child: Text(AppTranslations.of(context).text("edit_number"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0, color: Colors.black))),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                FirebaseAnalytics().logEvent(name: 'Otp Resend Button Clicked ',parameters:null);
                                  _saveUser(deviceId, mobile_number);
                                },
                              child: Text(AppTranslations.of(context).text("resend_otp"),textAlign: TextAlign.center ,style: TextStyle(fontSize: 14.0, color: Colors.black,fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



  _verifyOTP(String device_id,String mobile,String otp) async {
    _progressDialog.show();
    print(device_id);
    print(mobile);
    print(AppConstants.VERIFY_OTP);

    var response = await http.Client().post(AppConstants.VERIFY_OTP,
        body: {'device_id': device_id , 'mobile': mobile, 'country_code': "+91", 'otp': otp},
        headers: {"Accept": "application/json"});

    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.hide();
    if (jsonData['code'] == 200) {

      var token = jsonData['token'];

      _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, true);
      _sharedPreferences.setString(AppConstants.TOKEN, token);


      _referralCode();



    } else if (jsonData['code'] == 206){
      openInvalidOTPAlertBox(jsonData['message'].toString());
      //Fluttertoast.showToast(msg: jsonData['message'].toString());
    } else if (jsonData['code'] == 401) {
      Fluttertoast.showToast(msg: AppTranslations.of(context).text("log_out_msg"));
      _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    } else {
        Fluttertoast.showToast(msg: "some error occurred");
    }

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

      Fluttertoast.showToast(msg: "OTP code has been sent to your mobile number");

     // var otp_code = jsonData['otp_code'];
      // openAlertBox(otp_code.toString(), mobile);
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
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                      child: Text(
                        "OKAY!",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  openInvalidOTPAlertBox(String message) {
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
                    child: Text(message,textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("provide_the_valid_otp"),
                        textAlign:TextAlign.center,style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),


                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                      child: Text(
                        "OKAY!",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  void _referralCode(){

    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Wrap(

          children: [


            Center(
              child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Referral Code",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
            ),

            Container(
              margin: EdgeInsets.only(left:15,right: 15, bottom: 20,top: 30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

              child: ListView (

                scrollDirection: Axis.vertical,
                shrinkWrap: true,

                children: [
                  Padding(
                      padding: const EdgeInsets.only(top:15.0,left: 15.0),
                      child: Text("Enter your Friend Referral Code", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 12.0,right: 12.0,bottom: 10),
                      child: new TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: new InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                              hintText: "Enter Referral Code", counter: Container(),
                              border: InputBorder.none,
                              fillColor: Color(AppConstants.GRAY_COLOR[4])))),

                ],
              ),
            ),

            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 12, right: 12,bottom: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                  boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
              child: RaisedButton(
                color:Color(AppConstants.YELLOW_COLOR[0]),
                textColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                child: Text(AppTranslations.of(context).text("next"), style: TextStyle(color: Colors.black, fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                },
              ),
            ),

            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }
}

