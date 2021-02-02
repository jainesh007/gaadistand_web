
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/provide_taxi/create_post_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoPostScreen extends StatefulWidget {
  @override
  _NoPostScreenState createState() => new _NoPostScreenState();
}

class _NoPostScreenState extends State<NoPostScreen> {

  TextEditingController txt_mobile = new TextEditingController(text:'');
  SharedPreferences _sharedPreferences;
  int _selectedIndex=0;

  @override
  void initState() {
    super.initState();
    getAllDetails();
    FirebaseAnalytics().setCurrentScreen(screenName: 'Create Post Screen');
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
          child: Stack(

            children: <Widget>[

              ListView(
                children: <Widget>[

                  SizedBox(height:60.0),


                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(AppTranslations.of(context).text("no_provide_taxi"),style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold))),


                  Container(
                      height: 250,
                      child:Image.asset('assets/images/home_page_icon.png')),


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
                      child: Text(AppTranslations.of(context).text("create_post"), style: TextStyle(color: Colors.black, fontSize: 18)),
                      onPressed: () {
                        FirebaseAnalytics().logEvent(name: 'CreatePostScreen Button Clicked ',parameters:null);
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreatePostScreen()));
                      },
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar (
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi_outlined,size: 30,),
            label: 'Provide Taxi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined,size: 30,),
            label: 'Search Taxi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded,size: 30,),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(AppConstants.YELLOW_COLOR[0]),
        onTap: _onItemTapped,
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

