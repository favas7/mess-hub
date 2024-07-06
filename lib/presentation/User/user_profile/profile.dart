import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messhub/color/color.dart';
import 'package:messhub/functions/popAlert.dart';
import 'package:messhub/functions/profileTextBox.dart';
import 'package:messhub/presentation/User/user_profile/user_profile_edit.dart';

String loggedInUserEmail = '';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

Future<void> _loadUserData(Function(Map<String, String>) updateUser) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(user.email)
          .get();

      if (userData.exists) {
        var data = userData.data() as Map<String, dynamic>;
        String userName = data.containsKey('name') ? data['name'] : '';
        String email = data.containsKey('email') ? data['email'] : '';
        String phone = data.containsKey('phone') ? data['phone'] : '';
        String profileImage = data.containsKey('profileImage') ? data['profileImage'] : '';


        updateUser({
          'name': userName,
          'email': email,
          'phone': phone,
          'profileImage': profileImage,
        });
      } else {
      }
    // ignore: empty_catches
    } catch (e) {
    }
  } else {
  }
}

class _ProfileState extends State<Profile> {
  Map<String, String> userData = {
    'name': '',
    'email': '',
    'phone': '',
    'profileImage': '',
  };

  @override
  void initState() {
    super.initState();
    _loadUserData((data) {
      if (mounted) {
        setState(() {
          userData = data;
          loggedInUserEmail = data['email'] ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/adminProfile/profileBg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 33),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userData['profileImage'] != ''
                      ? NetworkImage(userData['profileImage']!)
                      : const AssetImage('assets/PlaceHolder/Placeholder_view_vector.svg.png')
                          as ImageProvider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfileEdit()),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              createTextBox('NAME', userData['name'] ?? ''),
              const SizedBox(
                height: 30,
              ),
              createTextBox('EMAIL', userData['email'] ?? ''),
              const SizedBox(
                height: 30,
              ),
              createTextBox('PHONE NUMBER', userData['phone'] ?? ''),
              const Spacer(),
              TextButton(
                onPressed: () {
                  showAlertDialog(context, "", Duration.zero);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(mainColor),
                ),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
