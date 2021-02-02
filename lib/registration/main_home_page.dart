
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/model/search_data_json.dart';
import 'package:gaadistand/provide_taxi/create_post_screen.dart';
import 'package:gaadistand/provide_taxi/edit_post_screen.dart';
import 'package:gaadistand/registration/login_screen.dart';
import 'package:get_version/get_version.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';




class MainHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainHomePageState();
  }
}

class _MainHomePageState extends State<MainHomePage> {

  DateTime currentBackPressTime;
  SharedPreferences _sharedPreferences;
  List<SearchResultDataResponse> all_list =  List<SearchResultDataResponse>();
  ProgressDialog _progressDialog;
  double img_height = 0;
  double img_width = 0;

  @override
  void initState() {
    super.initState();

    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));

    FirebaseAnalytics().setCurrentScreen(screenName: 'MainHomePage');

    AppConstants.checkInternetConnectivity().then((intenet) {
      if (intenet != null && intenet) {
        getAllDetails();
        print("Internet Available");
      } else {
        AppConstants.showAlertDialog(context);
      }
    });
  }


  Future<Null> _initPackageInfo() async {

    String projectVersion;
    try {
      projectVersion = await GetVersion.projectVersion;
    } on PlatformException {
      projectVersion = 'Failed to get build number.';
    }

    print("+++++>>>>>>");
    print(projectVersion);

    // App Type: 1 => android 2=> ios

    String platform = "";

    if(UniversalPlatform.isIOS) {
      platform = "2";
    } else if(UniversalPlatform.isAndroid){
      platform = "1";
    }

   _updateApp(platform, projectVersion);

  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    bool flag = _sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN);

    if(flag) {
      _searchTaxi();
    } else {
      setState(() {
        all_list.clear();
      });
      _initPackageInfo();
    }


  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(

      body: SafeArea(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: Column(
            children: <Widget>[

              Container(
                  child:  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 5,
                        child: Image.asset('assets/images/home_page_icon.png')),

                      Expanded(
                        flex: 4,
                        child: all_list.length != 0 ? InkWell(
                          highlightColor: Colors.white,
                          hoverColor: Colors.red,
                          onTap: () {


                            AppConstants.checkInternetConnectivity().then((intenet) {
                              if (intenet != null && intenet) {
                                print("Internet Available");

                                bool flag = _sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN);

                                if(flag) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreatePostScreen()));
                                } else {
                                  openLoginAlertBox();
                                }

                              } else {
                                AppConstants.showAlertDialog(context);
                              }
                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom:50.0),
                            child: Center(
                              child: Container(
                                height: 30,
                                width: 130,
                                decoration: BoxDecoration(
                                  color:Color(AppConstants.YELLOW_COLOR[1]),
                                  borderRadius: BorderRadius.only(topRight:  Radius.circular(10), bottomRight: Radius.circular(10),
                                      topLeft:  Radius.circular(15), bottomLeft: Radius.circular(15)),
                                ),
                                child: Row(
                                  children: [

                                    Image.asset('assets/images/plus.png'),

                                    Expanded(
                                        flex: 8,
                                        child: Center(child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(AppTranslations.of(context).text("create_post"),
                                              style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold)))))
                                  ],
                                ),
                              ),
                            ),
                          ),


                        ) : Container()),
                    ],
                  )
              ),

              SizedBox(height: 20.0),

              Container(
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child: Text(AppTranslations.of(context).text("provide_taxi"),
                      style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold))),

              SizedBox(height: 10),

              all_list.length != 0 ? Align(
                alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20,right: 20),
                    child: Text(AppTranslations.of(context).text("my_vehicles"),
                        style: TextStyle(fontSize: 15.0, color: Colors.black,  fontWeight: FontWeight.bold,))),
              ) : Container(),

              SizedBox(height: 10),


              all_list.length == 0 ?

              Container(
                  child: Column(
                  children: <Widget>[

                    SizedBox(height: 20),

                    Image.asset('assets/images/search_screen_icon.png',height: img_height,width: img_height,),

                    SizedBox(height: 30.0),

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
                        child: Text(AppTranslations.of(context).text("create_post"), style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
                        onPressed: () {
                          FirebaseAnalytics().logEvent(name: 'CreatePostScreen Button Clicked ',parameters:null);



                          AppConstants.checkInternetConnectivity().then((intenet) {
                            if (intenet != null && intenet) {
                              print("Internet Available");

                              bool flag = _sharedPreferences.getBool(AppConstants.KEY_IS_LOGGEDIN);

                              if(flag) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreatePostScreen()));
                              } else {
                                openLoginAlertBox();
                              }

                            } else {
                              AppConstants.showAlertDialog(context);
                            }
                          });



                        },
                      ),
                    ),

                  ],
                )) :

              Flexible(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: all_list.length,
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
                                                    child: Text(AppTranslations.of(context).text("pick_up"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold)))),


                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(AppTranslations.of(context).text("drop_off"), style: TextStyle(color: Colors.black,  fontSize: 15,fontWeight: FontWeight.bold)))),

                                             Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(all_list[index].is_round_trip == 0 ? "One-Way" : "Round Trip",
                                                        style: TextStyle(color: Colors.grey,  fontSize: 13,fontWeight: FontWeight.bold)))),




                                          ],
                                        ),

                                        Row(

                                          children: [

                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                                      child: Text(all_list[index].origin, style: TextStyle(color: Colors.black,  fontSize: 13,fontWeight: FontWeight.bold)))),
                                            ),

                                            Expanded(
                                              flex: 6,
                                              child: Row(
                                                children: [

                                                  Expanded(
                                                      child: Container(
                                                          height: 15,

                                                          decoration : all_list[index].is_round_trip != 0 ?  BoxDecoration(
                                                              color: Color(AppConstants.YELLOW_COLOR[0]),
                                                              gradient: LinearGradient(
                                                                  colors: [Color(AppConstants.YELLOW_COLOR[0]), Color(AppConstants.GRAY_COLOR[3])],
                                                                  end: Alignment(1.0, -2.0),
                                                                  begin: Alignment(1.0, 2.0),
                                                                  tileMode: TileMode.clamp,
                                                                  stops: [0.5, 0.5]),
                                                              shape: BoxShape.circle,
                                                              border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1,)

                                                          ) : BoxDecoration(color: Color(AppConstants.GRAY_COLOR[3]), shape: BoxShape.circle,
                                                              border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1,))

                                                      )),

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


                                                   Expanded(
                                                          child: Container(
                                                              height: 15,

                                                              decoration : all_list[index].is_round_trip != 0 ?  BoxDecoration(
                                                              color: Color(AppConstants.YELLOW_COLOR[0]),
                                                              gradient: LinearGradient(
                                                                      colors: [Color(AppConstants.YELLOW_COLOR[0]), Color(AppConstants.GRAY_COLOR[3])],
                                                                  begin: Alignment(1.0, -2.0),
                                                                  end: Alignment(1.0, 2.0),
                                                                      tileMode: TileMode.clamp,
                                                                      stops: [0.5, 0.5]),
                                                              shape: BoxShape.circle,
                                                              border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1,)

                                                          ) : BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]), shape: BoxShape.circle,
                                                                  border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 1,))

                                                          )),

                                                ],
                                              ),
                                            ),

                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child:Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Text(all_list[index].destination, style: TextStyle(color: Colors.black,  fontSize: 13,fontWeight: FontWeight.bold)))),
                                            ),
                                          ],
                                        ),

                                        Row(

                                          children: [

                                            Expanded(
                                              flex: 3,
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                                      child: Text("${dateConversion(all_list[index].availableDate)}, ${all_list[index].availableTime}", style: TextStyle(color: Colors.grey, fontSize: 12)))),
                                            ),

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
                                                    child: Text(AppTranslations.of(context).text("fare"), style: TextStyle(color: Colors.grey, fontSize: 13,fontWeight: FontWeight.bold)))),

                                            Align(
                                                alignment: Alignment.center,
                                                child:Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(AppTranslations.of(context).text("vehicle_type"), style: TextStyle(color: Colors.grey,  fontSize: 13,fontWeight: FontWeight.bold)))),


                                            Align(
                                                alignment: Alignment.centerRight,
                                                child:Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(AppTranslations.of(context).text("commission"), style: TextStyle(color: Colors.grey,  fontSize: 13,fontWeight: FontWeight.bold)))),


                                          ],
                                        ),

                                        Stack(

                                          children: [

                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(AppConstants.RUPEE_SYMBOL + ' ${all_list[index].fare}', style: TextStyle(color: Colors.grey, fontSize: 13,)))),


                                            Align(
                                                alignment: Alignment.center,
                                                child:Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text('${all_list[index].taxiTypeName}', style: TextStyle(color: Colors.grey,  fontSize: 13)))),



                                            Align(
                                                alignment: Alignment.centerRight,
                                                child:Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Text(AppConstants.RUPEE_SYMBOL + ' ${all_list[index].commision}', style: TextStyle(color: Colors.grey,  fontSize: 13)))),


                                          ],
                                        ),

                                        SizedBox(height: 10),

                                        Stack(

                                          children: [
                                            InkWell(
                                              onTap: (){
                                                _optionButtonClicked(all_list[index].uuid);
                                                openMoreAlertBox(all_list[index].uuid,all_list[index].origin,all_list[index].destination,
                                                    all_list[index].origin_id.toString(),all_list[index].destination_id.toString(),
                                                    all_list[index].availableDate,all_list[index].availableTime,all_list[index].fare.toString(),
                                                    all_list[index].commision.toString(),all_list[index].taxiTypeId.toString(),
                                                    all_list[index].taxiTypeName.toString(),all_list[index].feed_contacted.toString(),
                                                  all_list[index].is_round_trip);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(top: 5.0,left: 15,right: 15,bottom: 5),
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color:Color(AppConstants.YELLOW_COLOR[1]),
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0))),

                                                  child: Text(AppTranslations.of(context).text("options"),textAlign:TextAlign.center,
                                                      style: TextStyle(fontSize: 13.0,color: Colors.black,fontWeight: FontWeight.bold)),
                                              ),
                                            ),

                                            Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () async  {

                                                    _shareWhatsApp(all_list[index].uuid);

                                                    String urlString =  await Uri.encodeFull("whatsapp://send?text="
                                                        "${AppTranslations.of(context).text("taxi_available")} ${all_list[index].origin} to ${all_list[index].destination} \n"
                                                        + AppTranslations.of(context).text("date_msg") + " ${dateConversionRevers(all_list[index].availableDate)}, ${all_list[index].availableTime} \n"
                                                        + AppTranslations.of(context).text("vehicle") + " ${all_list[index].taxiTypeName}\n"
                                                        + AppTranslations.of(context).text("customer_charges") + " : ${all_list[index].fare}/-\n"
                                                        + AppTranslations.of(context).text("commission_offered") + " : ${all_list[index].commision}/-\n\n"
                                                        + AppTranslations.of(context).text("contact_at") + "${all_list[index].mobile} "
                                                        + AppTranslations.of(context).text("any_customer")+" \n\n"
                                                        + AppTranslations.of(context).text("absolutely_free") + "\n\n"
                                                        + AppConstants.PLAY_STORE_URL);

                                                  await launch(urlString);

                                                  },

                                                  child: Container(
                                                    height: 25,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      color:Color(AppConstants.GREEN_COLOR[0]),
                                                      borderRadius: BorderRadius.only(topRight:  Radius.circular(10), bottomRight: Radius.circular(10),
                                                          topLeft:  Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                    ),
                                                    child: Row(
                                                      children: [

                                                        Image.asset('assets/images/whatsapp.png',height: 25,width: 25),

                                                        Expanded(
                                                            flex: 8,
                                                            child: Center(child: Padding(
                                                              padding: const EdgeInsets.only(right: 8.0),
                                                              child: Text(AppTranslations.of(context).text("share"),
                                                                  style: TextStyle(color: Colors.black, fontSize: 13,fontWeight: FontWeight.bold)),
                                                            )))
                                                      ],
                                                    ),
                                                  ),

                                                )),

                                          ],
                                        ),

                                        SizedBox(height: 10),

                                        Text(AppTranslations.of(context).text("post_expire_msg")
                                            +"${postDateConversion(all_list[index].post_active_till)}" +
                                            AppTranslations.of(context).text("post_expire_msg_2"), style: TextStyle(color: Colors.grey, fontSize: 10))

                                      ],
                                    ),
                                  ),


                      );
                    }),
              ),

            ],
          ),
        ),
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

  openDismissAlertBox(String id) {
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
                    child: Text(AppTranslations.of(context).text("attention"),textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("dismiss_click"),
                        textAlign:TextAlign.center,style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),



                  Row(
                    children: [

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(right:1.0),
                          child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                            decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                            child: Text(AppTranslations.of(context).text("back"),
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ),
                        ),),


                      Expanded(
                          flex: 5,
                          child:InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _dismissPost(id);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                              decoration: BoxDecoration(color: Color(AppConstants.YELLOW_COLOR[0]),),
                              child: Text(
                                AppTranslations.of(context).text("confirm"),
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),

                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  openLoginAlertBox() {
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
                    child: Text("Oops!",textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("login_msg"),
                        textAlign:TextAlign.center,style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
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

  _searchTaxi() async {
    _progressDialog.show();
    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().get(AppConstants.LIST_USER_FEED,
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    _progressDialog.hide();
    print(jsonData);
    setState(() {
      all_list.clear();
      _progressDialog.hide();
      if (jsonData['code'] == 200) {

        setState(() {
          var jsonData = json.decode(response.body);
          var top_data = jsonData['response'] as List;
          for (var model in top_data) {
            all_list.add(new SearchResultDataResponse.fromJson(model));
          }
        });
      } else if (jsonData['code'] == 401) {
        Fluttertoast.showToast(msg: AppTranslations.of(context).text("log_out_msg"));
        _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
      }

      if(all_list.length==0) {
        img_height =120;
        img_width =120;
      }
      _progressDialog.hide();
      _initPackageInfo();

    });

  }

  _dismissPost(String id) async {
    _progressDialog.show();
    print(AppConstants.DISMISS_FEED);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().post(AppConstants.DISMISS_FEED,
        body: {'feed_uuid': id},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.hide();
    _searchTaxi();

  }

  _shareWhatsApp(String id) async {
    print(AppConstants.SHARE_WHATSAPP);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().post(AppConstants.SHARE_WHATSAPP,
        body: {'feed_uuid': id,"customer_search_uuid": ""},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    print(jsonData);
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

  String dateConversion(String start_date) {

    var inputFormat = DateFormat("yyyy-MM-dd");
    var date1 = inputFormat.parse(start_date);

    var outputFormat = DateFormat("dd MMM yyyy");

    var start = outputFormat.format(date1);

    return '${start}';

  }

  String dateConversionRevers(String start_date) {

    var inputFormat = DateFormat("yyyy-MM-dd");
    var date1 = inputFormat.parse(start_date);

    var outputFormat = DateFormat("dd-MM-yyyy");

    var start = outputFormat.format(date1);

    return '${start}';

  }

  String postDateConversion(String start_date) {

    var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var date1 = inputFormat.parse(start_date);

    var outputFormat = DateFormat("dd MMM yyyy, hh:mm a");

    var start = outputFormat.format(date1);

    return '${start}';

  }

  _updateApp(String app_type, String app_version) async {

    var response = await http.Client().post(AppConstants.APP_UPDATE,
        body: {"app_type":app_type,"app_version": app_version}, headers: {"Accept": "application/json"});

    var jsonData = json.decode(response.body);

    print(jsonData);

    if (jsonData['code'] == 200) {


      int soft_update = jsonData['soft_update'];
      int force_update = jsonData['force_update'];
      String description = jsonData['description'];


      if(force_update == 1) {
        _showVersionDialog(context,1,description);
      } else if(soft_update == 1) {
        _showVersionDialog(context,0,description);
      } else {
        print("app is up to date");
      }



    }

  }

  _showVersionDialog(context,int i,String description) async {

    await showDialog<String>(
      context: context,
      barrierDismissible: i == 1 ? false : true,
      builder: (BuildContext context) {

        String title = "New Update Available";

        String message = description.length !=0 ? description : AppTranslations.of(context).text("update_msg");

        String btnLabel = "Update Now";
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[

            FlatButton(child: Text(btnLabel), onPressed: () => _launchURL(AppConstants.PLAY_STORE_URL)),

            i == 0 ? FlatButton(child: Text("Later"), onPressed: () =>  Navigator.pop(context)) : Container()


          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openMoreAlertBox(String uuid,String origin,String destination,String origin_id,String destination_id, String feed_date,
      String feed_time, String fare, String commission, String taxiType, String taxiTypeName, String feed_contact, int round_trip) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(AppTranslations.of(context).text("select_option"),textAlign:TextAlign.center,style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
                    )),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 1,color: Colors.black)),


                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditPostScreen(origin, destination, origin_id,
                          destination_id, taxiType, taxiTypeName, feed_date, feed_time, fare, commission, uuid, feed_contact, round_trip)));
                      },

                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(AppTranslations.of(context).text("edit_post"),style: TextStyle(fontSize: 16.0, color: Colors.black)))),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 1,color: Colors.black)),


                  InkWell(
                    onTap: (){
                        Navigator.pop(context);
                        _copyFeed(uuid,"copy");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(AppTranslations.of(context).text("duplicate_post"),textAlign:TextAlign.left,style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 1,color: Colors.black,),
                  ),


                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _copyFeed(uuid,"repeated_next_day");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(AppTranslations.of(context).text("repeat_for_next_day"),textAlign:TextAlign.center,style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 1,color: Colors.black,),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      openDismissAlertBox(uuid);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(AppTranslations.of(context).text("dismiss"),
                          style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(height: 1,color: Colors.black,),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 5.0,left: 15,right: 15,bottom: 5),
                        height: 25,
                        decoration: BoxDecoration(
                            color:Color(AppConstants.YELLOW_COLOR[0]),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))),

                        child: Text(AppTranslations.of(context).text("close"),textAlign:TextAlign.center,
                            style: TextStyle(fontSize: 13.0,color: Colors.black,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,)




                ],
              ),
            ),
          );
        });
  }


  _copyFeed(String feed_uuid, String type) async {
    _progressDialog.show();
    print(AppConstants.COPY_FEED);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().post(AppConstants.COPY_FEED,
        body: {'feed_uuid': feed_uuid , 'type': type},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.hide();
    if (jsonData['code'] == 200) {
      _progressDialog.hide();
      _searchTaxiUpdate();
    } else if (jsonData['code'] == 206) {
      Fluttertoast.showToast(msg: jsonData['message'].toString());
    } else if (jsonData['code'] == 401) {
      Fluttertoast.showToast(msg: AppTranslations.of(context).text("log_out_msg"));
      _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    } else {
      Fluttertoast.showToast(msg: "some error occurred");
    }

  }

  _searchTaxiUpdate() async {

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().get(AppConstants.LIST_USER_FEED,
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    _progressDialog.hide();
    print(jsonData);
    setState(() {
      all_list.clear();
      _progressDialog.hide();
      if (jsonData['code'] == 200) {

        setState(() {
          var jsonData = json.decode(response.body);
          var top_data = jsonData['response'] as List;
          for (var model in top_data) {
            all_list.add(new SearchResultDataResponse.fromJson(model));
          }
        });
      } else if (jsonData['code'] == 401) {
        Fluttertoast.showToast(msg: AppTranslations.of(context).text("log_out_msg"));
        _sharedPreferences.setBool(AppConstants.KEY_IS_LOGGEDIN, false);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
      }

      if(all_list.length==0) {
        img_height =120;
        img_width =120;
      }
      _progressDialog.hide();
      _initPackageInfo();

    });

  }

  _optionButtonClicked(String id) async {
    print(id);
    print(AppConstants.OPTION_FEED);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var response = await http.Client().post(AppConstants.OPTION_FEED,
        body: {'feed_uuid': id},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);
    print(jsonData);
  }

}
