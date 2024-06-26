// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:messhub/color/color.dart';
import 'package:messhub/functions/profileTextBox.dart';
import 'package:messhub/presentation/admin/adminHome/detailsEdit.dart';
import 'package:messhub/presentation/User/user_home/menu_viewer.dart';

class AdminDetailsEdit extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final String id;

  const AdminDetailsEdit({Key? key, required this.index, required this.data, required this.id}) : super(key: key);

  @override
  State<AdminDetailsEdit> createState() => _AdminDetailsEditState();
}

class _AdminDetailsEditState extends State<AdminDetailsEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detailsedit(
                                index: widget.index,
                                data: widget.data, id: widget.id,
                              ),
                            ),
                          );
                },
          child: Row(
            children: [
              Text(widget.data['messname']),const Spacer(),
              const Text('Edit'),
              IconButton(onPressed: (){Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detailsedit(
                              index: widget.index,
                              data: widget.data, id: widget.id,
                            ),
                          ),
                        );
              }, icon: const Icon(Icons.edit))
            ],
          ),
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
              const SizedBox(
                height: 20,
              ),
              const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                'Description about the mess in detail to understand customer. Description about the mess in detail to understand ',
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
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
              const SizedBox(
                height: 20,
              ),
              const Text('Price Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Table(
          border: TableBorder.all(color: Colors.black),
          children:  [
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
                    child: Text(widget.data['fullplanveg']),
                  ),
                ),
                 TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.data['fullplan']),
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
                    child: Text(widget.data['lunchonlyveg']),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.data['lunchonly']),
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
                    child: Text(widget.data['twotimemealveg']),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), 
                    child: Text(widget.data['twotimemeal']),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        createTextBox('Mess Owner Name', widget.data['owner']),
        const SizedBox(
          height: 30,
        ), 
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
