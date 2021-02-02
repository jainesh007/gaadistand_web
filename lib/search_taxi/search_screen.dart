
import 'dart:convert';
import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/model/city_list_obejct.dart';
import 'package:gaadistand/search_taxi/search_result_screen.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController txt_pick_up = new TextEditingController(text:'');
  TextEditingController txt_drop_off = new TextEditingController(text:'');
  TextEditingController txt_date = new TextEditingController(text:'');

  GlobalKey<AutoCompleteTextFieldState<AllCities>> pick_key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<AllCities>> drop_key = new GlobalKey();
  List<AllCities> city_list = [];

  String pick_up_city_id ="";
  String drop_up_city_id ="";

  final format = DateFormat("yyyy-MM-dd");

  DateTime currentBackPressTime;
  ProgressDialog _progressDialog;
  SharedPreferences _sharedPreferences;

  bool flag =false;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Search Screen');
    loadCrossword();
    getAllDetails();
    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));
  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if(_sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN) == null) {
      flag =false;
    } else if(_sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN) == true) {
      flag =true;
    }

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(

      body: SafeArea(
        child: WillPopScope(
         onWillPop: onWillPop,
           child : Container(
             color: Colors.white,
               child: Stack(

                children: <Widget>[

                     ListView(
                          children: <Widget>[

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top:13),
                                child: Text(AppTranslations.of(context).text("search_taxi") ,style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
                              ),
                            ),

                            SizedBox(height: 30),

                            Padding(
                              padding: const EdgeInsets.only(left: 20.0,bottom: 5),
                              child: Text(AppTranslations.of(context).text("search_taxi_txt") ,style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
                            ),

                            SizedBox(height: 20),

                            Container(
                                margin: EdgeInsets.only(left:15,right: 15, bottom: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                                child: Column(
                                  children: <Widget>[

                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Padding(
                                              padding: const EdgeInsets.only(top:8.0,left: 10.0),
                                              child: Text(AppTranslations.of(context).text("pick_up"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                                          Padding(
                                            padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10),
                                            child: AutoCompleteTextField<AllCities>(
                                              key: pick_key,
                                              textInputAction: TextInputAction.done,
                                              decoration: new InputDecoration(
                                                prefixIcon:  Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Image.asset('assets/images/location_icon.png',height: 10,width: 10,),
                                                ),
                                                filled: true,
                                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 14),
                                                hintText: AppTranslations.of(context).text("enter_city"),
                                                border: InputBorder.none,
                                                fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                                              controller: txt_pick_up,
                                              suggestions: city_list,
                                              itemBuilder: (context, suggestion) => new Padding( padding: EdgeInsets.all(8.0),
                                                  child: Text(suggestion.value, style: TextStyle(color: Colors.black, fontSize: 13))),

                                              itemSorter: (a, b) => a.key == b.key ? 0 : a.key > b.key ? -1 : 1,
                                              itemFilter: (suggestion, input) => suggestion.value.toLowerCase().startsWith(input.toLowerCase()),

                                              clearOnSubmit: false,

                                              itemSubmitted: (item) => setState(() {
                                                txt_pick_up.text = item.value;
                                                pick_up_city_id = item.key.toString();
                                              }),


                                            ),
                                          ),

                                          Padding(padding: const EdgeInsets.only(top:15.0,left: 10.0),
                                              child: Text(AppTranslations.of(context).text("drop_off"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                                          Padding(
                                            padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10),
                                            child: AutoCompleteTextField<AllCities>(
                                              key: drop_key,
                                              textInputAction: TextInputAction.done,
                                              decoration: new InputDecoration(
                                                prefixIcon:  Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Image.asset('assets/images/location_icon.png',height: 10,width: 10,),
                                                ),
                                                filled: true,
                                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 14),
                                                hintText: AppTranslations.of(context).text("enter_city"),
                                                border: InputBorder.none,
                                                fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                                              controller: txt_drop_off,
                                              suggestions: city_list,
                                              itemBuilder: (context, suggestion) => new Padding( padding: EdgeInsets.all(8.0),
                                                  child: Text(suggestion.value, style: TextStyle(color: Colors.black, fontSize: 13))),

                                              itemSorter: (a, b) => a.key == b.key ? 0 : a.key > b.key ? -1 : 1,
                                              itemFilter: (suggestion, input) => suggestion.value.toLowerCase().startsWith(input.toLowerCase()),

                                              clearOnSubmit: false,

                                              itemSubmitted: (item) => setState(() {
                                                txt_drop_off.text = item.value;
                                                drop_up_city_id = item.key.toString();
                                              }),


                                            ),
                                          ),


                                          Padding(padding: const EdgeInsets.only(top:15.0,left: 10.0),
                                              child: Text(AppTranslations.of(context).text("date"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                                          Padding(
                                            padding: const EdgeInsets.only(top:5.0,left: 8.0,right: 10,bottom:8),
                                            child: DateTimeField(
                                              format: format,
                                              controller: txt_date,
                                              decoration: new InputDecoration(
                                                filled: true,
                                                prefixIcon:  Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: Image.asset('assets/images/date_icon.png',height: 10,width: 10,)),
                                                suffixIcon: new IconButton(
                                                  icon: Icon(Icons.add,size: 0,)),
                                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 14),
                                                hintText: AppTranslations.of(context).text("date"),
                                                border: InputBorder.none,
                                                fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                                                  onShowPicker: (context, currentValue) async {
                                                  DateTime picked = await showDatePicker(
                                                      context: context,
                                                      builder: (BuildContext context, Widget child) {
                                                        return Theme(
                                                          data: ThemeData.dark().copyWith(
                                                            colorScheme: ColorScheme.dark(
                                                              primary: Color(AppConstants.YELLOW_COLOR[0]),
                                                              onPrimary: Colors.black,
                                                              surface: Color(AppConstants.YELLOW_COLOR[0]),
                                                              onSurface: Colors.black,
                                                            ),
                                                            dialogBackgroundColor:Colors.white,
                                                          ),
                                                          child: child,
                                                        );
                                                      },
                                                    firstDate: DateTime.now(),
                                                    initialDate: currentValue ?? DateTime.now(),
                                                    lastDate: DateTime(2100));
                                                 return picked;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),

                            SizedBox(height: 5),

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
                                child: Text(AppTranslations.of(context).text("search"), style: TextStyle(color: Colors.black, fontSize: 18)),
                                onPressed: () {
                                  FirebaseAnalytics().logEvent(name: 'Search Button Clicked ',parameters:null);

                                  if (pick_up_city_id.length == 0) {
                                    Fluttertoast.showToast(msg:  AppTranslations.of(context).text("select_the_pick_up_city_drop_down"));
                                  } else if (drop_up_city_id.length == 0) {
                                    Fluttertoast.showToast(msg:  AppTranslations.of(context).text("select_the_drop_off_city_drop_down"));
                                  } else if (txt_date.text.length == 0) {
                                    Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_date"));
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SearchResultScreen(pick_up_city_id,drop_up_city_id,txt_date.text)));
                                  }
                                },
                              ),
                            ),

                            SizedBox(height: 10.0),

                  ],
                ),

              ],
          ),
        ),
      )),

    //  bottomNavigationBar: BottomNavigation(1),
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


  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/cities_list.json');
  }

  Future loadCrossword() async {
    String jsonCrossword = await _loadCrosswordAsset();
    _parseJsonForCrossword(jsonCrossword);
  }

  _parseJsonForCrossword(String jsonString) async {

    try {

      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['response'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        city_list.add(new AllCities.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }

    print(city_list.length);
  }
}

