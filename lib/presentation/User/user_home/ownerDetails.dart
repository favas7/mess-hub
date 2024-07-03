// ignore_for_file: file_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messhub/color/color.dart';
import 'package:messhub/functions/profileTextBox.dart';
import 'package:messhub/functions/sucsess_message.dart';
import 'package:messhub/presentation/User/user_home/menu_viewer.dart';
import 'package:messhub/widgets/bottomNavUser.dart';

class OwnerDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final String id;

  const OwnerDetails({
    Key? key,
    required this.index,
    required this.data,
    required this.id,
  }) : super(key: key);

  @override
  State<OwnerDetails> createState() => _OwnerDetailsState();
}

class _OwnerDetailsState extends State<OwnerDetails> {
  Future<void> saveSubscriptionToFirebase(Map<String, dynamic> sub) async {
    try {
      await FirebaseFirestore.instance.collection('subscribe').add(sub);
      showSuccessMessage(context, 'Mess subscrption request sent',duration: 2);
      showSuccessMessage(context, 'Please Wait untill admin accept your request',duration: 2); 
    } catch (e) {
      showSuccessMessage(context, 'Failed to subscribe',duration: 3);
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.data['messname']),
            const Spacer(),
            TextButton(
              onPressed: () {
                Map<String, dynamic> sub = {
                  'messname': widget.data['messname'],
                  'adminemail':widget.data['email'],
                  'username':userdetails?['name'],
                  'useremail': FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
                  'phone': userdetails?['phone'],
                  'adminphone': widget.data['contact'], 
                  'date':DateTime.now().toString(),
                }; 
                saveSubscriptionToFirebase(sub);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(mainColor),
              ),
              child: const Text(
                'Subscribe',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        widget.data['mainimage'],
                        height: 300,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Text(
                    'Description about the mess in detail to understand customer. Description about the mess in detail to understand ',
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Menuviewer(
                                index: widget.index,
                                data: widget.data,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(mainColor),
                        ),
                        child: const Text(
                          '                 CLICK HERE FOR MENU                 ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Price Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(' ', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('VEG', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('NON VEG', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Full Plan'),
                            ),
                          ),
                          TableCell( 
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('₹'+ widget.data['fullplan']),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('₹'+widget.data['fullplan']),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Lunch Only'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('₹'+widget.data['lunchonly']),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('₹'+widget.data['lunchonly']),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Two Times'),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('₹'+widget.data['twotimemeal']),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('₹'+widget.data['twotimemeal']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  createTextBox('Mess Owner Name', widget.data['owner']),
                  const SizedBox(height: 30),
                  createTextBox('Contact', widget.data['contact']),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
