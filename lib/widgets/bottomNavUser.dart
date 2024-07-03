// ignore_for_file: file_names

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:messhub/color/color.dart';
import 'package:messhub/functions/user_details.dart';
import 'package:messhub/presentation/User/user_home/home.dart';
import 'package:messhub/presentation/User/user_profile/profile.dart';
import 'package:messhub/presentation/User/user_data/user_data.dart';
Map<String, dynamic>?userdetails = {};
class BottomNavUser extends StatefulWidget {
  const BottomNavUser({Key? key}) : super(key: key);

  @override
  State<BottomNavUser> createState() => _BottomNavUserState();
}

class _BottomNavUserState extends State<BottomNavUser> {
  late PageController _userPageController;
  int _selectedIndexUser = 0;

  @override
  void initState() {
    super.initState();
    _userPageController = PageController(initialPage: _selectedIndexUser);
    fetchUserDetails();
  }

  @override
  void dispose() {
    _userPageController.dispose();
    super.dispose();
  }
Future<void> fetchUserDetails() async {
    setState(() {
      
    });
    Map<String, dynamic>? details = await loadUserData();
    setState(() {
      userdetails = details;
     
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _userPageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndexUser = index;
          });
        },
        children: const [
          Home(),
          UserData(),
          Profile(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: mainColor,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.calendar_month, title: 'Mess Details'), 
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndexUser,
        onTap: _userOnItemTapped,
        activeColor: white,
        curveSize: 100,
      ),
    );
  }

  void _userOnItemTapped(int index) {
    _userPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
