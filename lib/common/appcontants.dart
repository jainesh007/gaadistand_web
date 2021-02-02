

import 'package:device_info/device_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:universal_platform/universal_platform.dart';

class AppConstants {

  static final List BLUE_COLOR = [0xff00ADEF, 0xff8FD5EF];
  static final List GRAY_COLOR = [0xfff3f1f1, 0xffEFEFEF, 0xff9d9fa0,0xffe8e3e3,0xffedf0f4,0xffcedff6];
  static final List ORANGE_COLOR = [0xffff9900];
  static final List YELLOW_COLOR = [0xfffdcd03,0xfff9e3c9,0xffffe36a,0xfffde78b,0xffdddd08];
  static final List GREEN_COLOR = [0xffd3eed7];

  static final String RUPEE_SYMBOL = "\u20B9" ;

  // Live url
  // static final String API_SERVICE_LINK = "https://www.gaadistand.com/api/";

  // Staging url
  static final String API_SERVICE_LINK = "http://sandbox.gaadistand.com/api/";

  static final String SAVE_USER = API_SERVICE_LINK + "save-user";
  static final String SAVE_DEVICE_DATA = API_SERVICE_LINK + "save-device-data"; // 1 FOR ANDROID AND 2 FOR IOS
  static final String LIST_FEED = API_SERVICE_LINK + "list-feed";
  static final String LIST_FEED_LOGIN = API_SERVICE_LINK + "list-feed-login";
  static final String VERIFY_OTP = API_SERVICE_LINK + "verify-otp";
  static final String CREATE_FEED = API_SERVICE_LINK + "create-feed";
  static final String LIST_USER_FEED = API_SERVICE_LINK + "list-user-feed";
  static final String DISMISS_FEED = API_SERVICE_LINK + "dismiss-feed";
  static final String SHARE_WHATSAPP = API_SERVICE_LINK + "share-whatsapp";
  static final String CUSTOMER_CONTACT = API_SERVICE_LINK + "customer-contact";
  static final String VEHICLE_TYPES = API_SERVICE_LINK + "vehicle-types";
  static final String APP_UPDATE = API_SERVICE_LINK + "app-update";
  static final String COPY_FEED= API_SERVICE_LINK + "copy-feed";
  static final String OPTION_FEED= API_SERVICE_LINK + "option-feed";

  // shared_preferences values
  static final String KEY_IS_LOGGEDIN = "isLoggedIn";
  static final String LOGIN_AS = "login_as";
  static final String TOKEN = "token";
  static final String SELECTED_LANGUAGE = "language ";
  static final String APP_STORE_URL = "";
  static final String PLAY_STORE_URL = "https://play.google.com/store/apps/details?id=com.gaadistand.app";

  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (UniversalPlatform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    }
  }

  static Future<bool> checkInternetConnectivity() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static showAlertDialog(BuildContext context) async {
    return Alert(
      context: context,
      style: alertStyle,
      type: AlertType.info,
      title: 'GaadiStand',
      desc: "Internet connection not available",
      buttons: [
        DialogButton(
          child: Text("Okay", style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => Navigator.pop(context),
          color: Color(AppConstants.YELLOW_COLOR[0]),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  static var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.grey)),
    titleStyle: TextStyle(color: Colors.red),
  );


}