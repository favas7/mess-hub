
  import 'package:flutter/material.dart';

Widget header({required String heading}) {
    return Text(
      heading,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }