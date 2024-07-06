import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart'; 
import 'package:messhub/color/color.dart';
import 'package:messhub/hive/favmodel.dart';
import 'package:messhub/presentation/User/user_home/ownerDetails.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Keeping track of the favorite status
  final Map<String, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final box = Hive.box<dynamic>('favorites');
    final keys = box.keys;
    final favStatus = <String, bool>{};

    for (var key in keys) {
      favStatus[key] = true;
    }

    setState(() {
      _favorites.addAll(favStatus);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: adminBg,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("messdetails").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Data Found'));
          } else {
            List<QueryDocumentSnapshot> messDetails = snapshot.data!.docs;
            return ListView.builder(
              itemCount: messDetails.length,
              itemBuilder: (BuildContext context, int index) {
                var detail = messDetails[index];
                var id = detail.id;
                var details = {
                  'messname': detail.get('MessName') ?? '',
                  'owner': detail.get('OwnerName') ?? '',
                  'contact': detail.get('Contact') ?? '',
                  'address': detail.get('Address') ?? '',
                  'fullplan': detail.get('FullPlan') ?? '',
                  'twotimemeal': detail.get('TwoTimeMeal') ?? '',
                  'lunchonly': detail.get('LunchOnly') ?? '',
                  'mainimage': detail.get('mainImage') ?? '',
                  'vegimage': detail.get('vegImage') ?? '',
                  'nonvegimage': detail.get('nonVegImage') ?? '',
                  'fullplanveg': detail.get('FullPlanVeg') ?? '',
                  'twotimemealveg': detail.get('TwoTimeMealVeg') ?? '',
                  'lunchonlyveg': detail.get('LunchOnlyVeg') ?? '',
                  'email':detail.get('email')??'',
                  
                };

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnerDetails(
                            index: index,
                            data: details, id: id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 15,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: white,
                      ),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          _buildImage(detail.get('mainImage') ?? ''),
                          Positioned(
                            bottom: 100,
                            left: 16,
                            child: Text(
                              detail.get('MessName') ?? '',
                              style: GoogleFonts.oswald(
                                textStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 60,
                            left: 0,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {}, 
                                  icon: const Icon(Icons.location_on),
                                ),
                                Text(
                                  details['address'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.supervised_user_circle_sharp),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('subscribed')
                                      .where('adminemail', isEqualTo: details['email']) 
                                      .snapshots(),
                                  builder: (context, customerSnapshot) {
                                    if (customerSnapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (customerSnapshot.hasError) {
                                      return Text('Error: ${customerSnapshot.error}');
                                    }
                                    if (!customerSnapshot.hasData || customerSnapshot.data!.docs.isEmpty) {
                                      return const Text('0');
                                    }
                                    var customerCount = customerSnapshot.data!.docs.length;
                                    return Text('$customerCount');
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            bottom: 10,
                            left: 20,
                            child: Text(
                              'Description about the mess in detail to understand \n customer.Description about the mess in detail to \n understand',
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 95,
                            child: IconButton(
                              onPressed: () async {
                                if (_favorites[detail.id] == true) {
                                  await deletefav(id: details['messname']);
                                } else {
                                  await addfav(mess:details['messname'] , id: details['messname']);
                                }
                                setState(() {
                                  _favorites[detail.id] = !(_favorites[detail.id] ?? false);
                                });
                              },
                              icon: Icon(
                                Icons.favorite,
                                size: 30,
                                color: _favorites[detail.id] == true ? mainColor : black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      height: MediaQuery.of(context).size.height / 3.2,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return const Center(child: Icon(Icons.error));
      },
    );
  }
}
