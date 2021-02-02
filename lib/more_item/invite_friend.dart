
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InviteFriend extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InviteFriendState();
  }
}

class _InviteFriendState extends State<InviteFriend> {

  SharedPreferences _sharedPreferences;
  String copy_txt = "COPY";
  String invite_code = "GAADI65873";

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'More Section');
    getAllDetails();
  }

  getAllDetails() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.YELLOW_COLOR[0])));
    return Scaffold(

      body: SafeArea(

        child: Stack(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:15),
                    child: Text("Invite friend" ,style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: 30.0),

                Center(child: Image.asset('assets/images/gift.png',height: 140,width: 150,)),

                SizedBox(height: 20.0),


                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:15),
                    child: Text("Refer Your Friends, Earn CashBack" ,style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: 40.0),

                Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(width: 2,color: Color(AppConstants.YELLOW_COLOR[0]),style: BorderStyle.solid),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
                    child: Row(
                      children: [

                        Expanded(
                          flex: 6,
                            child: Container(
                                decoration: BoxDecoration(borderRadius:  BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)
                                ), color: Color(AppConstants.GRAY_COLOR[0])),
                              child:  Center(child: Text(invite_code, style: TextStyle(color:Color(AppConstants.YELLOW_COLOR[0]), fontSize: 18,fontWeight: FontWeight.bold))),
                            )),

                       Expanded(
                          flex: 4,
                            child: Container(
                                decoration: BoxDecoration(borderRadius:  BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                                  color: Color(AppConstants.YELLOW_COLOR[0])),
                              child:

                              InkWell(
                                  onTap : () {

                                    Clipboard.setData(new ClipboardData(text: invite_code));

                                    setState(() {
                                      copy_txt = "COPIED";
                                    });
                                  },
                                  child: Center(child: Text(copy_txt, style: TextStyle(color:Colors.white, fontSize: 18,fontWeight: FontWeight.bold)))),
                            )),


                      ],
                    )



                ),

                SizedBox(height: 10.0),

                Padding(
                  padding: const EdgeInsets.all(25),
                  child:  Text("INVITE Earn 10 points when your friend "
                      "uses your invite code during signup and perform the following activities Create Post | Search Post |"
                      " Whatsapp Share | Contact Driver", textAlign: TextAlign.center ,style: TextStyle(color: Colors.black54,
                      fontSize: 13,fontWeight: FontWeight.bold)),
                ),


                SizedBox(height: 30.0),

                Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 12, right: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2), blurRadius: 90, offset: Offset(0, 90))]),
                    child: RaisedButton(
                        color:Color(AppConstants.YELLOW_COLOR[0]),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                        child: Text("INVITE NOW", style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
                        onPressed: () {
                          FirebaseAnalytics().logEvent(name: 'INVITE NOW Button Clicked',parameters:null);
                          final RenderBox box = context.findRenderObject();

                          Share.share("Download GaadiStand app and my Refferal code is $invite_code",
                              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

                        })
                ),


                SizedBox(height: 10.0),

              ],
            ),

            BackButton(color: Colors.black)


          ],
        ),
      ),
    );
  }
}

