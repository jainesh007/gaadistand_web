
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_picker/Picker.dart';
import 'package:gaadistand/home_page.dart';
import 'package:gaadistand/registration/login_screen.dart';
import 'package:gaadistand/registration/main_home_page.dart';
import 'package:gaadistand/model/search_data_json.dart';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaadistand/model/city_list_obejct.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_picker/flutter_picker.dart';


class EditPostScreen extends StatefulWidget {

  String origin, destination, origin_id, destination_id, taxiType, taxiTypeName, feed_date, feed_time,fare, commission, uuid, feed_contact;
  int round_trip;


  EditPostScreen(this.origin, this.destination, this.origin_id, this.destination_id, this.taxiType,this.taxiTypeName,
      this.feed_date,this.feed_time,this.fare,this.commission,this.uuid,this.feed_contact,this.round_trip);

  @override
  State<StatefulWidget> createState() {
    return _EditPostScreenState(origin, destination,origin_id, destination_id, taxiType,taxiTypeName,feed_date,feed_time,fare,commission,uuid,feed_contact,round_trip);
  }
}

class _EditPostScreenState extends State<EditPostScreen> {

  String origin, destination,origin_id, destination_id, taxiType, taxiTypeName, feed_date, feed_time,fare, commission, uuid, feed_contact;
  int round_trip;

  _EditPostScreenState(this.origin, this.destination, this.origin_id, this.destination_id, this.taxiType, this.taxiTypeName,this.feed_date,this.feed_time,
      this.fare,this.commission,this.uuid, this.feed_contact, this.round_trip);

  TextEditingController txt_pick_up = new TextEditingController(text:'');
  TextEditingController txt_drop_off = new TextEditingController(text:'');

  TextEditingController txt_date = new TextEditingController(text:'');
  TextEditingController txt_time = new TextEditingController(text:'');
  TextEditingController txt_fare = new TextEditingController(text:'');
  TextEditingController txt_commission = new TextEditingController(text:'');

  String pick_up_city_id ="";
  String drop_up_city_id ="";

  String _vehicletype = null;
  String _vehicletype_id = null;
  final date_format = DateFormat("yyyy-MM-dd");
  final time_format = DateFormat("hh:mm a");

  GlobalKey<AutoCompleteTextFieldState<AllCities>> pick_key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<AllCities>> drop_key = new GlobalKey();
  List<AllCities> city_list = [];
  List<VehicleResponse> vehicle_type_list =  List<VehicleResponse>();

  ProgressDialog _progressDialog;
  SharedPreferences _sharedPreferences;

  int selectTripType = 0;

  setSeletedValue(int val) {
    setState(() {
      selectTripType = val;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Edit Post Screen');

    selectTripType = round_trip;

    loadCrossword();

    _vehicleType();

    _progressDialog = ProgressDialog(context, showLogs: true);
    _progressDialog.style(message: 'Please wait...', progressWidget: Container(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()));
    getAllDetails();


    txt_drop_off.text = destination;
    txt_pick_up.text = origin;
    txt_date.text = feed_date;
    txt_time.text = feed_time;
    txt_commission.text = commission;
    txt_fare.text = fare;

    pick_up_city_id = origin_id;
    drop_up_city_id =destination_id;

    _vehicletype = taxiTypeName;
    _vehicletype_id = taxiType;

  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
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

                  Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(color: Colors.black)),

                  Padding(
                    padding: const EdgeInsets.only(left:20.0, bottom: 20),
                    child: Text(AppTranslations.of(context).text("edit_your_post") ,style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),

                  Container(
                    margin: EdgeInsets.only(left:15,right: 15, bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0),
                              child: Text(AppTranslations.of(context).text("trip_type"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),


                          Container(
                            margin: const EdgeInsets.only(left: 10.0, right: 10.0,top:8.0,),
                            color: Color(AppConstants.GRAY_COLOR[4]),
                            child : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: 0,
                                  groupValue: selectTripType,
                                  onChanged: (val) {
                                    setSeletedValue(val);
                                  },
                                ),
                                new Text(
                                  'One Way',
                                  style: new TextStyle(fontSize: 16.0),
                                ),
                                new Radio(
                                  value: 1,
                                  groupValue: selectTripType,
                                  onChanged: (val) {
                                    setSeletedValue(val);
                                  },
                                ),
                                new Text(
                                  'Round Trip',
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                              child: Text(AppTranslations.of(context).text("pick_up"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                            child: AutoCompleteTextField<AllCities>(
                              key: pick_key,
                              textInputAction: TextInputAction.done,
                              decoration: new InputDecoration(
                                prefixIcon:  Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset('assets/images/location_icon.png',height: 10,width: 10,),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
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

                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                              child: Text(AppTranslations.of(context).text("drop_off"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                            child: AutoCompleteTextField<AllCities>(
                              key: drop_key,
                              textInputAction: TextInputAction.done,
                              decoration: new InputDecoration(
                                prefixIcon:  Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset('assets/images/location_icon.png',height: 10,width: 10,),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
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


                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0),
                              child: Text(AppTranslations.of(context).text("car_type"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                            child: Container(
                              height: 50,
                              child: DropdownButtonHideUnderline(
                                  child: InputDecorator(
                                    decoration:  new InputDecoration(
                                      filled: true,
                                      prefixIcon:  Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset('assets/images/car_type.png',height: 10,width: 10,),
                                      ),
                                      hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                                      border: InputBorder.none,
                                      fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                                    child:  DropdownButton(
                                      underline: SizedBox(),
                                      hint: _vehicletype == null
                                          ? Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Text(AppTranslations.of(context).text("select_car_type"),
                                              style: TextStyle(color: Colors.grey, fontSize: 14)))
                                          : Padding(padding: EdgeInsets.only(right: 5),
                                          child: Text(_vehicletype, style: TextStyle(color: Colors.black, fontSize: 14))),
                                      isExpanded: true,
                                      iconSize: 30.0,
                                      style: TextStyle(color: Colors.black),
                                      items: vehicle_type_list.map(
                                            (VehicleResponse response) {
                                          return DropdownMenuItem<VehicleResponse>(value: response, child: Text(response.type));
                                        },
                                      ).toList(),
                                      onChanged: (VehicleResponse response) {
                                        setState(
                                              () {
                                            _vehicletype = response.type.toString();
                                            _vehicletype_id = response.id.toString();
                                            /*    _vehicle_type_value = response.value;

                                                    print(driven_type);*/

                                            FocusScope.of(context).requestFocus(new FocusNode());
                                          },
                                        );
                                      },
                                    ),
                                  )
                              ),
                            ),
                          ),


                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0),
                              child: Text(AppTranslations.of(context).text("date"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                            child: DateTimeField(
                              format: date_format,
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
                                setState(() {
                                  txt_time.text ="";
                                });
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

                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0),
                              child: Text(AppTranslations.of(context).text("time"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                            child: InkWell(
                              onTap: () {

                                if(txt_date.text.length !=0) {
                                  String current_date = DateFormat("yyyy-MM-dd").format(DateTime.now());

                                  if(current_date == txt_date.text) {
                                    showPickerDateTime(context,1);
                                  } else {
                                    showPickerDateTime(context,0);
                                  }
                                } else {
                                  Fluttertoast.showToast(msg: "Please select date first");
                                }

                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: txt_time,
                                  decoration: new InputDecoration(
                                    filled: true,
                                    prefixIcon:  Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset('assets/images/time_icon.png',height: 10,width: 10,)),
                                    suffixIcon: new IconButton(icon: Icon(Icons.add,size: 0,)),
                                    hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                                    hintText: AppTranslations.of(context).text("time"),
                                    border: InputBorder.none,
                                    fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                                ),
                              ),
                            ),
                          ),

                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0),
                              child: Text(AppTranslations.of(context).text("customer_charges"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                            child: new TextField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              controller: txt_fare,
                              maxLength: 6,
                              decoration: new InputDecoration(
                                filled: true,
                                prefixIcon:  Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset('assets/images/rs_icon.png',height: 10,width: 10,),
                                ),
                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                                hintText: AppTranslations.of(context).text("enter_amount"), counter: Container(),
                                border: InputBorder.none,
                                fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                            ),
                          ),

                          Padding(padding: const EdgeInsets.only(top:8.0,left: 10.0),
                              child: Text(AppTranslations.of(context).text("commission"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                            child: new TextField(
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              controller: txt_commission,
                              maxLength: 6,
                              decoration: new InputDecoration(
                                filled: true,
                                prefixIcon:  Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset('assets/images/rs_icon.png',height: 10,width: 10,),
                                ),
                                hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                                hintText: AppTranslations.of(context).text("enter_amount"), counter: Container(),
                                border: InputBorder.none,
                                fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),

                  SizedBox(height: 10),

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
                      child: Text(AppTranslations.of(context).text("update"), style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(name: 'publish Button Clicked',parameters:null);

                        if (pick_up_city_id.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_the_pick_up_city_drop_down"));
                        } else if (drop_up_city_id.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_the_drop_off_city_drop_down"));
                        } else if (_vehicletype.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_vehicle_type"));
                        } else if (txt_date.text.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_date"));
                        } else if (txt_time.text.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_time"));
                        } else if (txt_fare.text.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_customer_charges"));
                        } else if (txt_commission.text.length == 0) {
                          Fluttertoast.showToast(msg: AppTranslations.of(context).text("select_commission"));
                        } else {

                          int fare =  int.parse(txt_fare.text);
                          int commission =  int.parse(txt_commission.text);

                          if(fare > commission) {
                            _createFeed(pick_up_city_id, drop_up_city_id, txt_date.text, txt_time.text, txt_fare.text, txt_commission.text, _vehicletype_id);
                          } else {
                            Fluttertoast.showToast(msg: AppTranslations.of(context).text("fare_greater_then_commission"));
                          }
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
      ),
    );
  }

  showPickerDateTime(BuildContext context, int setMinTime) {

    Picker(
      adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kHM_AP,
          isNumberMonth: false,
          minValue: setMinTime == 1 ? DateTime.now() : DateTime(2020, 12, 12),
          minuteInterval: 1,
          minHour: 1,
          maxHour: 23,
          maxValue: DateTime(2025, 12, 31)),
      hideHeader: true,
      title: new Text("Select Time", textAlign: TextAlign.center),
      confirmTextStyle : TextStyle(color: Colors.black),
      cancelTextStyle : TextStyle(color: Colors.black),
      // confirmText: "Okay",
      textAlign: TextAlign.right,
      selectedTextStyle: TextStyle(color: Color(AppConstants.YELLOW_COLOR[0])),
      delimiter: [
        PickerDelimiter(
            column: 1,
            child: Container(
                width: 16.0,
                alignment: Alignment.center,
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                color: Colors.white)),
        PickerDelimiter(
            column: 3,
            child: Container(
                width: 16.0,
                alignment: Alignment.center,
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                color: Colors.white))
      ],
      onConfirm: (Picker picker, List value) {
        setState(() {
          DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(picker.adapter.text);
          var outputFormat = DateFormat("hh:mm a");
          var start = outputFormat.format(tempDate);
          txt_time.text = start;
          print(start);
        });
      },
    ).showDialog(context);
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

  openAlertBox() {
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
                    child: Text(AppTranslations.of(context).text("thank_you"),textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text(AppTranslations.of(context).text("thank_you_msg"),
                        textAlign:TextAlign.center,style: TextStyle(fontSize: 13.0, color: Colors.black)),
                  ),



                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                      // Navigator.pop(context);
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

  _createFeed(String origin,String destination,String feed_date,String feed_time,String fare,String commission,String taxi_type) async {
    _progressDialog.show();
    print(AppConstants.CREATE_FEED);

    String token = _sharedPreferences.getString(AppConstants.TOKEN);

    var is_update = feed_contact == "1" ? "0" : "1";

    print("+++++>>>>>>>");
    print(is_update);
    print(uuid);
    print(feed_contact);

    var response = await http.Client().post(AppConstants.CREATE_FEED,
        body: {'origin': origin , 'destination': destination, 'feed_date': feed_date, "feed_time": feed_time, "fare": fare,
          "commission": commission, "taxi_type": taxi_type,"feed_uuid" : uuid, "is_update" : is_update, "is_round_trip": '$selectTripType'},
        headers: {"Accept": "application/json", 'Authorization': 'Bearer $token'});

    var jsonData = json.decode(response.body);

    print(jsonData);
    _progressDialog.hide();
    if (jsonData['code'] == 200) {
      openAlertBox();

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

  _vehicleType() async {

    var response = await http.Client().get(AppConstants.VEHICLE_TYPES, headers: {"Accept": "application/json"});

    var jsonData = json.decode(response.body);
    _progressDialog.hide();
    print(jsonData);
    setState(() {
      vehicle_type_list.clear();

      if (jsonData['code'] == 200) {
        setState(() {
          var jsonData = json.decode(response.body);
          var top_data = jsonData['response'] as List;
          for (var model in top_data) {
            vehicle_type_list.add(new VehicleResponse.fromJson(model));
          }
        });
      }
    });

  }


}

// 1,74 i5 m10
// 1.42