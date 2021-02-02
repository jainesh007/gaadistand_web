import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gaadistand/common/app_translations.dart';
import 'package:gaadistand/common/appcontants.dart';
import 'package:gaadistand/depot/reward_screen.dart';
import 'package:gaadistand/more_item/more_item_section.dart';
import 'package:gaadistand/registration/main_home_page.dart';
import 'package:gaadistand/search_taxi/search_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final _pageOptions = [MainHomePage(), SearchScreen(), RewardSection(), MoreSection()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pageOptions[currentPage],

      bottomNavigationBar: BubbleBottomBar(
        hasNotch: true,
        opacity: .8,
        currentIndex: currentPage,
        onTap: changePage,
        elevation: 8,

        items: <BubbleBottomBarItem>[

          BubbleBottomBarItem(
              backgroundColor: Color(AppConstants.YELLOW_COLOR[0]),
              icon: Icon(
                Icons.local_taxi_outlined,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.local_taxi_outlined,
                color: Colors.black,
              ),
              title: Text(AppTranslations.of(context).text("navigation_provide_taxi").toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold))),

          BubbleBottomBarItem(
              backgroundColor: Color(AppConstants.YELLOW_COLOR[0]),
              icon: Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
              title: Text(AppTranslations.of(context).text("search_taxi").toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold))),

          BubbleBottomBarItem(
              backgroundColor: Color(AppConstants.YELLOW_COLOR[0]),
              icon: ImageIcon(AssetImage('assets/images/reward.png'),
                color: Colors.black,
              ),
              activeIcon: ImageIcon(AssetImage('assets/images/reward.png'),
                color: Colors.black,
              ),
              title: Text(AppTranslations.of(context).text("depot").toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold))),

          BubbleBottomBarItem(
              backgroundColor: Color(AppConstants.YELLOW_COLOR[0]),
              icon: Icon(
                Icons.list_rounded,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.list_rounded,
                color: Colors.black,
              ),
              title: Text(AppTranslations.of(context).text("more").toUpperCase(),
                  style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold)))

        ],
      ),
    );
  }

  void changePage(int index) {
    setState(() {
      currentPage = index;
    });
  }
}