// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:messhub/color/color.dart';
import 'package:messhub/functions/popAlert.dart';
import 'package:messhub/functions/profileTextBox.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
          height: MediaQuery.of(context).size.height, 
          width: MediaQuery.of(context).size.width,
          child: Image.asset('assets/adminProfile/profileBg.png',
          fit: BoxFit.cover,),
        ),
        Positioned(
          top: 50, left: 165,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/PlaceHolder/Placeholder_view_vector.svg.png')
             ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 250),
              createTextBox('NAME', 'NAME OF ADMIN'),
              const SizedBox(
                height: 30,
              ),
              createTextBox('EMAIL', 'EMAIL OF ADMIN'),
            const SizedBox(
                height: 30, 
              ),
              createTextBox('PHONE NUMBER', 'PHONE NUMBER OF ADMIN'),
              const Spacer(),
              Center(
                child: TextButton(onPressed: (){
                  
                            showAlertDialog(context,"",Duration.zero); 
                },
                style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(mainColor),
                      ),
                       child: const Text('LOG OUT',style: TextStyle(
                        color: black
                       ),)),
              )
            ],
          ),
        )
        ]
      )
    );
  }
}



