import 'package:flutter/material.dart';

class MonthlyCounter extends StatefulWidget {
  final DateTime date;
  final DateTime year;
  const MonthlyCounter({super.key, required this.date, required this.year});

  @override
  // ignore: library_private_types_in_public_api
  _MonthlyCounterState createState() => _MonthlyCounterState();
}

class _MonthlyCounterState extends State<MonthlyCounter> {
  int _daysElapsed = 0;
  int _totalDaysInMonth = 0;

  @override
  void initState() {
    super.initState();
    _calculateDays();
  }

  void _calculateDays() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = widget.date;
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      _daysElapsed = now.difference(firstDayOfMonth).inDays + 1;
      _totalDaysInMonth = lastDayOfMonth.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Days elapsed this month:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_daysElapsed / $_totalDaysInMonth',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}