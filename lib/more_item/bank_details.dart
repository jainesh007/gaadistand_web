
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';


class BankDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BankDetailsState();
  }
}

class _BankDetailsState extends State<BankDetails> {


  TextEditingController txt_beneficiary_name = new TextEditingController();
  TextEditingController txt_bank_name = new TextEditingController();
  TextEditingController txt_branch_name = new TextEditingController();
  TextEditingController txt_ifsc_code = new TextEditingController();
  TextEditingController txt_account_number = new TextEditingController();
  TextEditingController txt_confirm_account_number = new TextEditingController();

  TextEditingController txt_phone_pe_number = new TextEditingController();
  TextEditingController txt_google_pay_number = new TextEditingController();
  TextEditingController txt_paytm_number = new TextEditingController();

  TextEditingController txt_upi_number = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(AppConstants.BLUE_COLOR[0])));

    return Scaffold(

      body: SafeArea(

        child: Stack(

          children: <Widget>[

            BackButton(),

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:15),
                    child: Text(AppTranslations.of(context).text("bank_details") ,style: TextStyle(fontSize: 18.0, color: Colors.black,fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0,bottom: 5),
                  child: Text(AppTranslations.of(context).text("bank_details_txt") ,style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 50.0),

                Divider(height: 2,color: Colors.black,),

                SizedBox(height: 10.0),

                InkWell(
                  onTap: () {
                    _settingModalBottomSheetBankTransfer();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(AppTranslations.of(context).text("bank_transfer") ,style: TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.arrow_drop_down_circle_sharp),
                      ),
                    ],
                  ),
                ),



                SizedBox(height: 10.0),

                Divider(height: 2,color: Colors.black,),

                SizedBox(height: 10.0),

                InkWell(
                  onTap: () {
                    _settingModalBottomSheetMobileTransfer();
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(AppTranslations.of(context).text("mobile_transfer") ,style: TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.arrow_drop_down_circle_sharp),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.0),

                Divider(height: 2,color: Colors.black,),


                SizedBox(height: 10.0),

                InkWell(
                  onTap: () {
                    _settingModalBottomSheetUPITransfer();
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(AppTranslations.of(context).text("upi_transfer") ,style: TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.arrow_drop_down_circle_sharp),
                      ),
                    ],
                  ),
                ),



                SizedBox(height: 10.0),

                Divider(height: 2,color: Colors.black,),


                SizedBox(height: 10.0),





              ],
            ),


          ],
        ),
      ),
    );
  }


  void _settingModalBottomSheetBankTransfer(){

    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              child: Padding(padding: EdgeInsets.only(top: 20), child: Text(AppTranslations.of(context).text("bank_details"),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
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
                      padding: const EdgeInsets.only(top:8.0,left: 10.0),
                      child: Text(AppTranslations.of(context).text("account_number"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                    child: new TextField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      controller: txt_account_number,
                      decoration: new InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                        hintText: AppTranslations.of(context).text("enter_account_number"), counter: Container(),
                        border: InputBorder.none,
                        fillColor: Color(AppConstants.GRAY_COLOR[4])))),

                  Padding(padding: const EdgeInsets.only(top:15.0,left: 10.0),
                      child: Text(AppTranslations.of(context).text("confirm_account_number"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                    child: new TextField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      controller: txt_confirm_account_number,
                      decoration: new InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                        hintText: AppTranslations.of(context).text("confirm_enter_account_number"), counter: Container(),
                        border: InputBorder.none,
                        fillColor: Color(AppConstants.GRAY_COLOR[4])))),


                  Padding(padding: const EdgeInsets.only(top:15.0,left: 10.0),
                      child: Text(AppTranslations.of(context).text("beneficiary_name"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                    child: new TextField(
                      textInputAction: TextInputAction.done,
                      controller: txt_beneficiary_name,
                      decoration: new InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                        hintText: AppTranslations.of(context).text("enter_account_holder_name"), counter: Container(),
                        border: InputBorder.none,
                        fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                    ),
                  ),


                  Padding(padding: const EdgeInsets.only(top:15.0,left: 10.0),
                      child: Text(AppTranslations.of(context).text("ifsc_code"), style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                    child: new TextField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      controller: txt_ifsc_code,
                      decoration: new InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                        hintText: AppTranslations.of(context).text("enter_ifsc_code"), counter: Container(),
                        border: InputBorder.none,
                        fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                    ),
                  ),
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
                child: Text(AppTranslations.of(context).text("save"), style: TextStyle(color: Colors.black, fontSize: 18)),
                onPressed: () {

                },
              ),
            ),

            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }


  void _settingModalBottomSheetMobileTransfer(){

    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              child: Padding(padding: EdgeInsets.only(top: 20), child: Text(AppTranslations.of(context).text("payment_through_phone_number"),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
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
                      padding: const EdgeInsets.only(top:15.0,left: 15.0),
                      child: Text("Phone pe", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 12.0,right: 12.0),
                      child: new TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          controller: txt_phone_pe_number,
                          decoration: new InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                              hintText: AppTranslations.of(context).text("mobile_number"), counter: Container(),
                              border: InputBorder.none,
                              fillColor: Color(AppConstants.GRAY_COLOR[4])))),


                  Center(child: Text("OR",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),

                  Padding(padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Google Pay", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),


                  Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 12.0,right: 12.0),
                      child: new TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          controller: txt_google_pay_number,
                          decoration: new InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                              hintText: AppTranslations.of(context).text("mobile_number"), counter: Container(),
                              border: InputBorder.none,
                              fillColor: Color(AppConstants.GRAY_COLOR[4])))),


                  Center(child: Text("OR",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),

                  Padding(padding: const EdgeInsets.only(left: 15.0),
                      child: Text("Paytm", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),




                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left: 12.0,right: 12.0),
                    child: new TextField(
                      textInputAction: TextInputAction.done,
                      controller: txt_paytm_number,
                      decoration: new InputDecoration(
                        filled: true,
                        hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                        hintText: AppTranslations.of(context).text("mobile_number"), counter: Container(),
                        border: InputBorder.none,
                        fillColor: Color(AppConstants.GRAY_COLOR[4]),),
                    ),
                  ),
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
                child: Text(AppTranslations.of(context).text("save"), style: TextStyle(color: Colors.black, fontSize: 18)),
                onPressed: () {

                },
              ),
            ),

            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }


  void _settingModalBottomSheetUPITransfer(){

    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Add UPI",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
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
                      padding: const EdgeInsets.only(top:15.0,left: 15.0),
                      child: Text("UPI", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold))),

                  Padding(
                      padding: const EdgeInsets.only(top:8.0,left: 12.0,right: 12.0,bottom: 10),
                      child: new TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          controller: txt_phone_pe_number,
                          decoration: new InputDecoration(
                              filled: true,
                              hintStyle: TextStyle(color: Color(AppConstants.GRAY_COLOR[2]),fontSize: 15),
                              hintText: "Enter your UPI Id", counter: Container(),
                              border: InputBorder.none,
                              fillColor: Color(AppConstants.GRAY_COLOR[4])))),

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
                child: Text(AppTranslations.of(context).text("save"), style: TextStyle(color: Colors.black, fontSize: 18)),
                onPressed: () {

                },
              ),
            ),

            SizedBox(height: 20.0),

          ],
        ),
      ),
    );
  }
}
