// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messhub/functions/heading.dart';
import 'package:messhub/functions/textbox.dart';
import 'package:messhub/presentation/User/user_data/monthly_counter.dart';
import 'package:messhub/presentation/logIn/logIn.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:messhub/color/color.dart';
import 'package:url_launcher/url_launcher.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});
  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String? messName;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<DateTime> _markedDays = List.generate(30, (index) => DateTime.now().add(Duration(days: index)));
  Map<String, dynamic>? userdetails;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('userDetails').doc(user.email).get();
      setState(() {
        userdetails = userData.data() as Map<String, dynamic>;
      });
      fetchMessName();
    }
  }

  Future<void> fetchMessName() async {
    if (userdetails == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('subscribed')
          .where('useremail', isEqualTo: userdetails!['email'])
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          messName = querySnapshot.docs.first.data()['messname'];
        });
      } else {
        setState(() {
          messName = 'Mess Details';
        });
      }
    } catch (e) {
      setState(() {
        messName = 'Mess Details';
      });
    }
  }

  void callnumber(String phonenumber) async {
    Uri dialNumber = Uri(scheme: 'tel', path: '+91$phonenumber');
    await launchUrl(dialNumber);
  }

  void directcall() async {
    await FlutterPhoneDirectCaller.callNumber('+91 9847549722');
  }

  DateTime _getDateFromData(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.parse(date);
    } else {
      throw Exception('Invalid date format');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      userdetails = null;
      messName = null;
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(messName ?? 'Mess details'),
        backgroundColor: mainColor,
      ),
      body: userdetails == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('subscribed')
                  .where('useremail', isEqualTo: userdetails!['email'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data found'));
                }

                var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                DateTime firestoreDate = _getDateFromData(data['date']);

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2022, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: firestoreDate,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, focusedDay) {
                                if (_markedDays.contains(day)) {
                                  return Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: day.isBefore(DateTime.now()) ? Colors.grey : Colors.blue,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: const TextStyle().copyWith(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: MonthlyCounter(date: firestoreDate, year: firestoreDate, userdetails: userdetails!),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              children: [
                                header(heading: 'Food reaching time'),
                                const SizedBox(height: 30),
                                createTextBox('Breakfast', '09:00 AM'),
                                createTextBox('Lunch', '01:00 PM'),
                                createTextBox('Dinner', '07:00 AM'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              callnumber(data['adminphone']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                            ),
                            child: const Text(
                              'Contact Mess Owner',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
