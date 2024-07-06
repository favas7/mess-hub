import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MonthlyCounter extends StatefulWidget {
  final DateTime date;
  final DateTime year;
  final Map<String, dynamic> userdetails;

  const MonthlyCounter({
    super.key,
    required this.date,
    required this.year,
    required this.userdetails,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MonthlyCounterState createState() => _MonthlyCounterState();
}

class _MonthlyCounterState extends State<MonthlyCounter> {
  int _daysElapsed = 0;
  int _remainingDays = 0;
  int totalDaysInMonth = 30; // Assuming the month has 30 days

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionDate();
  }

  Future<void> _fetchSubscriptionDate() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('subscribed')
          .where('useremail', isEqualTo: widget.userdetails['email'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        var subscriptionDate = _getDateFromData(data['date']);
        _calculateDays(subscriptionDate);
      } else {
      }
    // ignore: empty_catches
    } catch (e) {
    }
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

  void _calculateDays(DateTime subscribedDate) {
    DateTime now = DateTime.now();

    setState(() {
      _daysElapsed = now.difference(subscribedDate).inDays + 1;
      _remainingDays = totalDaysInMonth - _daysElapsed;
      if (_remainingDays < 0) {
        _remainingDays = 0; // Ensure the remaining days don't go negative
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Days elapsed since subscribed:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '$_daysElapsed',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Remaining days in month:',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '$_remainingDays',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
