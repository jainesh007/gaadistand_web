import 'dart:async';
import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/common/application.dart';
import 'package:gaadistand/home_page.dart';
import 'package:gaadistand/registration/select_language.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList = application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  SharedPreferences _sharedPreferences;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String deviceId;
  String deviceToken;
  String deviceType;

  _navigateTo(bool flag) {
    if(flag) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SelectLanguage()));
    }

  }

  void _select(String language) {
    print("dd "+language);
    application.onLocaleChanged = onLocaleChange;
    onLocaleChange(Locale(languagesMap[language]));

    _sharedPreferences.setString(AppConstants.SELECTED_LANGUAGE, language);

    // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoginScreen()));
  }


  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  getLoginDetails() async {

    _sharedPreferences = await SharedPreferences.getInstance();
    deviceId = await _getId();
    print(deviceId);
    _getToken();

    if(_sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN) == null) {
      _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
    } else {
      print("=========>>>>>>>>>>");
    }

    if(_sharedPreferences.getString(AppConstants.SELECTED_LANGUAGE) == null) {
      _sharedPreferences.setString(AppConstants.SELECTED_LANGUAGE, "English");
    } else {
      _select(_sharedPreferences.getString(AppConstants.SELECTED_LANGUAGE));
    }
  }
  @override
  void initState() {
    super.initState();
    _configureFireBaseMessaging();
    getLoginDetails();

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);

    Timer(Duration(seconds: 4), () => _navigateTo(_sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN)));




  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(
        backgroundColor:Colors.white,
        body: Stack(
          children: <Widget>[
           
           
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(AppConstants.YELLOW_COLOR[0]),
                    borderRadius: BorderRadius.circular(45.0)),
                child: Padding(padding: EdgeInsets.all(30.0), child: Image(image: AssetImage('assets/images/app_logo.png'),height: 130,width: 130,)
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child:Padding(padding: EdgeInsets.all(8.0), child: Image(image: AssetImage('assets/images/made_in_india_image.png'))))
          ],
        )
    );
  }

  _getToken() {
    _fcm.getToken().then((value){
      deviceToken = value;
      print("Device Token is : ${value}");
      _savePhoneData(deviceId, value, deviceType);
    });
  }

  _configureFireBaseMessaging() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var jsonData = json.decode(message.toString());
        print("1231231213213: $jsonData");
        showNotification("Gaadi Stand", "1234");
      },

      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },

      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (UniversalPlatform.isIOS) {
      deviceType = "2";
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS

    } else if (UniversalPlatform.isAndroid) {
      deviceType = "1";
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;

    /*  var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android*/
    }
  }

  Future onSelectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  showNotification(String title, String otp) async {
    var android = AndroidNotificationDetails('id', 'channel', 'description', priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, 'Your Otp is : ${otp}', platform, payload: 'Welcome to the Local Notification demo');
  }

  _savePhoneData(String device_id,String device_token, String app_type) async {

    var response = await http.Client().post(AppConstants.SAVE_DEVICE_DATA,
        body: {'device_id': device_id , 'device_token': device_token, 'app_type': app_type},
        headers: {"Accept": "application/json"});



  }
}
