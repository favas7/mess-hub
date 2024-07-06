// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messhub/color/color.dart';
import 'package:messhub/functions/sucsess_message.dart';

class UserRequest extends StatefulWidget {
  const UserRequest({super.key});

  @override
  State<UserRequest> createState() => _UserRequestState();
}

class _UserRequestState extends State<UserRequest> {
  User? user = FirebaseAuth.instance.currentUser;
  late String? email = user?.email;

  List<DocumentSnapshot> subscription = [];

  Future<void> fetchSubscriptions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('subscribe')
          .where('adminemail', isEqualTo: email)
          .get();

      setState(() {
        subscription = querySnapshot.docs;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching subscriptions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSubscriptions();
  }

  Future<void> acceptSubscription(DocumentSnapshot subscription) async {
    try {
      var subscriptionData = subscription.data() as Map<String, dynamic>;
      await FirebaseFirestore.instance.collection('subscribed').add(subscriptionData);
      await FirebaseFirestore.instance.collection('subscribe').doc(subscription.id).delete();
      showSuccessMessage(context, 'Subscription accepted', duration: 2);
      fetchSubscriptions();
    } catch (e) {
      showSuccessMessage(context, 'Failed to accept subscription', duration: 2);
    }
  }

  Future<void> declineSubscription(DocumentSnapshot subscription) async {
    try {
      await FirebaseFirestore.instance.collection('subscribe').doc(subscription.id).delete();
      showSuccessMessage(context, 'Subscription declined', duration: 2);
      fetchSubscriptions();
    } catch (e) {
      showSuccessMessage(context, 'Failed to decline subscription', duration: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Requests'),
        backgroundColor: mainColor,
      ),
      body: SafeArea(
        child: subscription.isEmpty
            ? const Center(
                child: Text(
                  'No requests found',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: subscription.length,
                      itemBuilder: (context, index) {
                        var subscriptionDoc = subscription[index];
                        var subscriptionData = subscriptionDoc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text('${subscriptionData['username']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${subscriptionData['useremail']}'),
                              Text('Phone: ${subscriptionData['phone']}'),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => declineSubscription(subscriptionDoc),
                                  icon: const Icon(Icons.cancel),
                                ),
                                IconButton(
                                  onPressed: () => acceptSubscription(subscriptionDoc),
                                  icon: const Icon(Icons.check_box_rounded),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
