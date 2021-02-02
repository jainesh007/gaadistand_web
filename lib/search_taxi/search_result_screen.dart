import 'dart:convert';
import 'dart:ui';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/model/search_data_json.dart';
import 'package:gaadistand/registration/login_screen.dart';
import 'package:gaadistand/search_taxi/login_search_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class SearchResultScreen extends StatefulWidget {

  String pick_up_city_id;
  String drop_off_city_id;
  String selected_date;

  SearchResultScreen(this.pick_up_city_id,this.drop_off_city_id,this.selected_date);

  @override
  State<StatefulWidget> createState() {
    return _SearchResultScreenState(pick_up_city_id,drop_off_city_id, selected_date);
  }
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  String pick_up_city_id;
  String drop_off_city_id;
  String selected_date;
  String customer_search_uuid ="0";

  _SearchResultScreenState(this.pick_up_city_id,this.drop_off_city_id,this.selected_date);

  DateTime dateTime;
  ProgressDialog _progressDialog;
  DateFormat dateFormat;

  List<SearchResultDataResponse> all_list =  List<SearchResultDataResponse>();
  SharedPreferences _sharedPreferences;
  DatePickerController _controller = DatePickerController();


  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Search Result Screen');

    print(pick_up_city_id);
    print(drop_off_city_id);
    print(selected_date);

    dateFormat = DateFormat("yyyy-MM-dd");
    dateTime = dateFormat.parse(selected_date);

    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));

    getAllDetails();

  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();


    bool flag = _sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN);

    if(flag) {
      _searchTaxiLogin(pick_up_city_id, drop_off_city_id, selected_date, customer_search_uuid);
    } else {
      _searchTaxi(pick_up_city_id, drop_off_city_id, selected_date, customer_search_uuid);
    }



    _controller.animateToDate(dateTime.subtract(Duration(days: 2)));

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
              Column(

                  children: <Widget>[

                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:  Text(AppTranslations.of(context).text("result") ,style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
                      )),

                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: dateTime,
                    selectionColor:  Color(AppConstants.YELLOW_COLOR[0]),
                    selectedTextColor: Colors.black,
                    daysCount:30,
                    controller: _controller,
                    onDateChange: (date) {
                      setState(() {
                        selected_date = dateFormat.format(date);
                        customer_search_uuid = "0";
                      });

                      String select_date = dateFormat.format(date);

                      bool flag = _sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN);

                      if(flag) {
                        _searchTaxiLogin(pick_up_city_id, drop_off_city_id, select_date, customer_search_uuid);
                      } else {
                        _searchTaxi(pick_up_city_id, drop_off_city_id, select_date, customer_search_uuid);
                      }


                    },
                  ),

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:  Text(AppTranslations.of(context).text("available_taxis") ,style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold)),
                      )),


                    all_list.length == 0 ?
                    Container(

                      child: Column(
                        children: <Widget>[

                          SizedBox(height: 50),

                          Image.asset('assets/images/search_screen_icon.png'),


                          SizedBox(height: 20),

                          Text(AppTranslations.of(context).text("no_available_taxis_msg") ,style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold))

                        ],
                      ),
                    ) :

                    Flexible(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: all_list.length,
                        itemBuilder: (context, index) {

                          return Container(
                              margin: EdgeInsets.only(left:10,right: 10, bottom: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                                  color:Color(AppConstants.GRAY_COLOR[4]),
                                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))],
                                 ),

                              child: Column(
                                children: <Widget>[

                                  InkWell(
                                      onTap: () {
                                        FirebaseAnalytics().logEvent(name: 'Post Clicked ',parameters:null);
                                      },
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
                                                        child: Text(AppTranslations.of(context).text("pick_up"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)))),


                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppTranslations.of(context).text("drop_off"), style: TextStyle(color: Colors.black,  fontSize: 15,fontWeight: FontWeight.bold)))),

                                              ],
                                            ),

                                            Row(

                                              children: [

                                                Expanded(
                                                  flex: 4,
                                                  child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(padding: const EdgeInsets.all(4.0),
                                                          child: Text(all_list[index].origin, style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold)))),
                                                ),

                                                Expanded(
                                                  flex: 6,
                                                  child: Row(
                                                    children: [
                                                      Expanded(child: Container(
                                                          height: 15,
                                                          decoration: BoxDecoration(
                                                              color:Color(AppConstants.GRAY_COLOR[3]), shape: BoxShape.circle,
                                                              border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1)))),

                                                      Expanded(
                                                        flex: 8,
                                                        child: Row(
                                                          children: List.generate(250~/10, (index) => Expanded(
                                                            child: Container(
                                                              color: index%2==0?Colors.transparent
                                                                  :Colors.grey,
                                                              height: 2,
                                                            ),
                                                          )),
                                                        ),
                                                      ),

                                                      Expanded(child: Container(
                                                          height: 15,
                                                          decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]), shape: BoxShape.circle,
                                                              border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1)))),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  flex: 4,
                                                  child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child:Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Text(all_list[index].destination, style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold)))),
                                                ),
                                              ],
                                            ),


                                            SizedBox(height: 10),

                                            Stack(

                                              children: [

                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppTranslations.of(context).text("vehicle_type"), style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.bold)))),

                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child:Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppTranslations.of(context).text("available_time"), style: TextStyle(color: Colors.grey,  fontSize: 14,fontWeight: FontWeight.bold)))),


                                              ],
                                            ),

                                            Stack(

                                              children: [

                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(all_list[index].taxiTypeName, style: TextStyle(color: Colors.grey, fontSize: 13,)))),


                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child:Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(all_list[index].availableTime, style: TextStyle(color: Colors.grey,  fontSize: 13)))),


                                              ],
                                            ),

                                            SizedBox(height: 10),

                                            Stack(

                                              children: [

                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: InkWell(
                                                      onTap: () {
                                                        openInfoAlertBox(all_list[index].fare, all_list[index].commision);
                                                      },
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(left: 45.0,top: 5),
                                                          child: Icon(Icons.info_outline_rounded,color: Colors.grey ,size: 15,)),
                                                    )),

                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppTranslations.of(context).text("fare"), style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.bold)))),

                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child:Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppTranslations.of(context).text("commission"), style: TextStyle(color: Colors.grey,  fontSize: 14,fontWeight: FontWeight.bold)))),


                                              ],
                                            ),

                                            Stack(

                                              children: [

                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppConstants.RUPEE_SYMBOL + "${all_list[index].fare}", style: TextStyle(color: Colors.grey, fontSize: 13,)))),

                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child:Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Text(AppConstants.RUPEE_SYMBOL + "${all_list[index].commision}", style: TextStyle(color: Colors.grey,  fontSize: 13)))),


                                              ],
                                            ),

                                            SizedBox(height: 10),

                                            Stack(

                                              children: [


                                                Text(timeStamp(all_list[index].hour, all_list[index].minute), style: TextStyle(color: Colors.grey, fontSize: 10)),

                                                all_list[index].own_booking == 0 ?

                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () {

                                                        bool flag = _sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN);

                                                        if(flag) {
                                                          launch("tel:${all_list[index].mobile}");
                                                          _customerContact(all_list[index].uuid, selected_date, customer_search_uuid);
                                                        } else {
                                                          openLoginAlertBox();
                                                        }


                                                      },
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 5.0),
                                                            child: Image.asset('assets/images/contact.png',height: 18,width: 18),
                                                          ),

                                                          Container(
                                                            padding: const EdgeInsets.only(top: 5.0,left: 15,right: 15,bottom: 5),
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                                color:Color(AppConstants.GRAY_COLOR[5]),
                                                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                            child: Text(AppTranslations.of(context).text("contact"), style: TextStyle(fontSize: 13.0,color: Colors.black,
                                                                fontWeight: FontWeight.bold)),
                                                          ),

                                                        ],
                                                      ),
                                                    )
                                                ) :

                                                Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          InkWell(
                                                          onTap: () {
                                                            openMyPostAlertBox();
                                                          },
                                                            child: Container(
                                                              padding: const EdgeInsets.only(top: 5.0,left: 15,right: 15,bottom: 5),
                                                              height: 25,
                                                              decoration: BoxDecoration(
                                                                  color:Color(AppConstants.GRAY_COLOR[5]),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                                              child: Text(AppTranslations.of(context).text("my_post"), style: TextStyle(fontSize: 13.0,color: Colors.black,
                                                                  fontWeight: FontWeight.bold)),
                                                            ),
                                                          ),

                                                        ],
                                                      ),

                                                ),



                                              ],
                                            ),

                                          ],
                                        ),
                                      )),
                                ],
                              )
                          );

                        }),
                  )

                ],
              ),

              BackButton(color: Colors.black),
            ],


          ),
        ),
      ),
    );
  }


  _searchTaxi(String pick_up,String drop_off, String search_date, String customer_serach_uuid) async {

    _progressDialog.show();
    print(pick_up);
    print(drop_off);
    print(search_date);
    print(customer_serach_uuid);
    print(AppConstants.LIST_FEED);

    var response = await http.Client().post(AppConstants.LIST_FEED,
        body: {'origin': pick_up , 'destination': drop_off, 'customer_serach_uuid': customer_serach_uuid, 'search_date': search_date},
        headers: {"Accept": "application/json"});

    var jsonData = json.decode(response.body);
    _progressDialog.hide();
    print(jsonData);
    setState(() {
      all_list.clear();
      customer_search_uuid  = jsonData['customer_search_uuid'];

      if (jsonData['code'] == 200) {
        setState(() {
          var jsonData = json.decode(response.body);
          var top_data = jsonData['response'] as List;
          for (var model in top_data) {
            all_list.add(new SearchResultDataResponse.fromJson(model));
          }
        });
      } if (jsonData['code'] == 202) {
        // openAlertBox(jsonData['message'].toString());
      } else {

      }

      print("+++++++>>>>>>>>>>>");
      print(all_list.length);

    });

  }

  _searchTaxiLogin(String pick_up,String drop_off, String search_date, String customer_serach_uuid) async {

    _progressDialog.show();
    print(pick_up);
    print(drop_off);
    print(search_date);
    print(customer_serach_uuid);
    print(AppConstants.LIST_FEED);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().post(AppConstants.LIST_FEED_LOGIN,
        body: {'origin': pick_up , 'destination': drop_off, 'customer_serach_uuid': customer_serach_uuid, 'search_date': search_date},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    _progressDialog.hide();
    print(jsonData);
    setState(() {
      all_list.clear();
      customer_search_uuid  = jsonData['customer_search_uuid'];

      if (jsonData['code'] == 200) {
        setState(() {
          var jsonData = json.decode(response.body);
          var top_data = jsonData['response'] as List;
          for (var model in top_data) {
            all_list.add(new SearchResultDataResponse.fromJson(model));
          }
        });
      } if (jsonData['code'] == 202) {
        // openAlertBox(jsonData['message'].toString());
      } else if (jsonData['code'] == 401) {
        Fluttertoast.showToast(msg: AppTranslations.of(context).text("log_out_msg"));
        _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
      } else {

      }

      print("+++++++>>>>>>>>>>>");
      print(all_list.length);

    });

  }

  _customerContact(String id, String search_date, String customer_search_uuid) async {
    print(AppConstants.CUSTOMER_CONTACT);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().post(AppConstants.CUSTOMER_CONTACT,
        body: {'feed_uuid': id,"customer_search_uuid": customer_search_uuid,"search_date": search_date},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    print(jsonData);
  }

  openLoginAlertBox() {
    return showDialog(
        context: context,
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
                    child: Text("Oops!",textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("login_msg"),
                        textAlign:TextAlign.center,style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),



                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SearchLoginScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                      child: Text(AppTranslations.of(context).text("login"),
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

  openInfoAlertBox(int fare, int commission) {
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
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(AppTranslations.of(context).text("fare_breakdown"),textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("customer_charges")+ " : ${fare}",
                        style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("commission_offered")+ " : ${commission}",
                        style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),


               /*   Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("total_fare")+ " : ${fare - commission}",
                        style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),*/



                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                      child: Text("OKAY!",
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

  String timeStamp(String hour, String minute) {


    int h = int.parse(hour);
    int m = int.parse(minute);

    if(h!=0) {
      return  AppTranslations.of(context).text("posted")
          + " $h "+ AppTranslations.of(context).text("hour")
          + " $m "+ AppTranslations.of(context).text("minutes")
          +" "+AppTranslations.of(context).text("ago");
    } else {
      return  AppTranslations.of(context).text("posted")
          + " $m "+ AppTranslations.of(context).text("minutes")
          + " "+AppTranslations.of(context).text("ago");
    }
  }


  openMyPostAlertBox() {
    return showDialog(
        context: context,
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
                    child: Text(AppTranslations.of(context).text("please_note"),textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold))),

                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("my_post_msg"), textAlign:TextAlign.center,style: TextStyle(fontSize: 13.0, color: Colors.black))),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                      child: Text("OKAY!", style: TextStyle(color: Colors.white), textAlign: TextAlign.center))),
                ],
              ),
            ),
          );
        });
  }
}

