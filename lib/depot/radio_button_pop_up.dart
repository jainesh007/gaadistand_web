import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';


class RedeemRadioButton extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RedeemRadioButton();
  }
}

class _RedeemRadioButton extends State<RedeemRadioButton> {

  int _radioValue1 = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10,top: 15),
              child: Text("TRANSFER 50 INR", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, color: Colors.blue,fontWeight: FontWeight.bold)),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10,top: 5),
              child: Text("500 points =  50 INR", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.bold)),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left:15,right: 15, bottom: 20,top: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))]),

            child: ListView (

              scrollDirection: Axis.vertical,
              shrinkWrap: true,

              children: [

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 8.0,top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('4356xxxxxxx6890',
                        style: new TextStyle(fontSize: 16.0),
                      ),

                      Radio(
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: (int value) {
                          setState(() => _radioValue1 = value);
                        },
                      ),

                    ],
                  ),
                ),

                Divider(color: Colors.grey),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      new Text(
                        '98348xxxxx@upi',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),

                      new Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: (int value) {
                          setState(() => _radioValue1 = value);
                        },
                      ),


                    ],
                  ),
                ),

                Divider(color: Colors.grey),

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 8.0,bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('9828767xxxxx (Phone Pe)',
                        style: new TextStyle(fontSize: 16.0),
                      ),

                      Radio(
                        value: 2,
                        groupValue: _radioValue1,
                        onChanged: (int value) {
                          setState(() => _radioValue1 = value);
                        },
                      ),


                    ],
                  )),

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
                  child: Text("CONFIRM", style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold)),
                  onPressed: () {

                    Navigator.pop(context);
                    openInfoAlertBox();

                  })
          ),
        ],
      ),
    );
  }


  openInfoAlertBox() {
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
                    child: Text("Congratulations!",textAlign:TextAlign.center,style: TextStyle(fontSize: 22.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 30.0,left: 13, right: 13),
                    child: Text("Your redeem request of 50 INR Bank Transfer has been received and will be processed within 3 working days. \n\n "
                        "Enjoy your time with GaadiStand",
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
}