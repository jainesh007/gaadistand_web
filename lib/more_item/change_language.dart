import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/common/application.dart';
import 'package:gaadistand/home_page.dart';
import 'package:gaadistand/registration/main_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => new _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList = application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String label = languagesList[0];
  SharedPreferences _sharedPreferences;
  String selectLanguage;
  bool hindi_language_select = false;
  bool english_language_select = false;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    getAllDetails();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Change Language');
  }


  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      String language = _sharedPreferences.getString(AppConstants.SELECTED_LANGUAGE);
      if(language.toLowerCase() == "hindi") {
        hindi_language_select = true;
        english_language_select = false;
      } else {
        english_language_select = true;
        hindi_language_select = false;
      }

    });

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
                          color: hindi_language_select ? Color(AppConstants.YELLOW_COLOR[0]) : Color(AppConstants.GRAY_COLOR[0]),
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                          child: Text("Hindi", style: TextStyle(color: Colors.black, fontSize: 18)),
                          onPressed: () {
                            FirebaseAnalytics().logEvent(name: 'Hindi Language Button Clicked ', parameters: null);
                            setState(() {
                              english_language_select = false;
                              hindi_language_select = true;
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
                          color: english_language_select ? Color(AppConstants.YELLOW_COLOR[0]) : Color(AppConstants.GRAY_COLOR[3]),
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                          child: Text("English", style: TextStyle(color: Colors.black, fontSize: 18)),
                          onPressed: () {
                            FirebaseAnalytics().logEvent(name: 'English Language Button Clicked ', parameters: null);
                            setState(() {
                              hindi_language_select = false;
                              english_language_select = true;
                              selectLanguage = "English";
                              _select(selectLanguage);
                              FocusScope.of(context).requestFocus(new FocusNode());
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 50),

                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
                        child: RaisedButton(
                          color: Color(AppConstants.YELLOW_COLOR[0]),
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                          child: Text("Done", style: TextStyle(color: Colors.black, fontSize: 18)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                          },
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
}