import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/common/application.dart';
import 'package:gaadistand/registration/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => new _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList = application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String label = languagesList[0];
  SharedPreferences _sharedPreferences;
  String selectLanguage;
  bool language_select = true;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    getAllDetails();
    application.onLocaleChanged = onLocaleChange;
    onLocaleChange(Locale(languagesMap["Hindi"]));

    FirebaseAnalytics().setCurrentScreen(screenName: 'Select Language');
  }


  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }


  void _select(String language) {
    print("dd "+language);
    onLocaleChange(Locale(languagesMap[language]));

    setState(() {
      if (language == "Hindi") {
        label = "हिंदी";
      } else {
        label = language;
      }
    });

    _sharedPreferences.setString(AppConstants.SELECTED_LANGUAGE, language);

    // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoginScreen()));
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

                  SizedBox(height: 30),

                  Container(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Image.asset('assets/images/city_driver_cuate.png'))),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Choose Your Language',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center),
                  ),

                  SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
                    child: RaisedButton(
                      color: language_select ? Color(AppConstants.YELLOW_COLOR[0]) : Color(AppConstants.GRAY_COLOR[0]),
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                      child: Text("HINDI", style: TextStyle(color: Colors.black, fontSize: 18)),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(name: 'Hindi Language Button Clicked ', parameters: null);
                        setState(() {
                          language_select = true;
                          selectLanguage = "Hindi";
                          _select(selectLanguage);
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
                    child: RaisedButton(
                      color: !language_select ? Color(AppConstants.YELLOW_COLOR[0]) : Color(AppConstants.GRAY_COLOR[3]),
                      textColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                      child: Text("ENGLISH", style: TextStyle(color: Colors.black, fontSize: 18)),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(name: 'English Language Button Clicked ', parameters: null);
                        setState(() {
                          language_select = false;
                          selectLanguage = "English";
                          _select(selectLanguage);
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 30),

                  Center(
                    child: InkWell(
                      onTap: () {
                        // FirebaseCrashlytics.instance.crash();
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "NEXT ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),
                            ),
                            WidgetSpan(
                              child:  Image.asset('assets/images/next_arrow.png',height: 18,width: 18,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ],
          ),
        )),
      ),

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