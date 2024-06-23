import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_supplier_app/main_screens/category.dart';
import 'package:ecommerce_supplier_app/main_screens/dashboard.dart';
import 'package:ecommerce_supplier_app/main_screens/home.dart';
import 'package:ecommerce_supplier_app/main_screens/stores.dart';
import 'package:ecommerce_supplier_app/main_screens/upload_product.dart';
import 'package:ecommerce_supplier_app/services/notifications_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CaterogyScreen(),
    const StoresScreen(),
    DashBoardScreen(),
    const UploadProductScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        NotificationsServices.displayNotification(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliverystatus', isEqualTo: 'preparing')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            body: _tabs[_selectedIndex],
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: _selectedIndex,
              onTap: (i) => setState(() {
                _selectedIndex = i;
              }),
              items: [
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text(
                    "Home",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  selectedColor: Colors.blue,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.category),
                  title: Text(
                    "Categories",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  selectedColor: Colors.blue,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.shop),
                  title: Text(
                    "Stores",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  selectedColor: Colors.blue,
                ),
                SalomonBottomBarItem(
                  icon: Badge(
                    showBadge: snapshot.data!.docs.isEmpty ? false : true,
                    badgeStyle: BadgeStyle(badgeColor: Colors.blue),
                    badgeContent: Text(
                      snapshot.data!.docs.length.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Icon(Icons.dashboard),
                  ),
                  title: Text(
                    "Dashboard",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  selectedColor: Colors.blue,
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.upload_file_sharp),
                  title: Text(
                    "Upload",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  selectedColor: Colors.blue,
                ),
              ],
            ),
          );
          // return Scaffold(
          //   body: _tabs[_selectedIndex],
          //   bottomNavigationBar: BottomNavigationBar(
          //     elevation: 0,
          //     type: BottomNavigationBarType.fixed,
          //     selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          //     selectedItemColor: Colors.blue,
          //     currentIndex: _selectedIndex,
          //     items: [
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.home),
          //         label: 'Home',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.category),
          //         label: 'Caterogy',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.shop),
          //         label: 'Stores',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Badge(
          //           showBadge: snapshot.data!.docs.isEmpty ? false : true,
          //           badgeStyle: BadgeStyle(badgeColor: Colors.blue),
          //           badgeContent: Text(
          //             snapshot.data!.docs.length.toString(),
          //             style: const TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           child: Icon(Icons.dashboard),
          //         ),
          //         label: 'Dashboard',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.upload),
          //         label: 'Upload',
          //       ),
          //     ],
          //     onTap: (index) {
          //       setState(() {
          //         _selectedIndex = index;
          //       });
          //     },
          //   ),
          // );
        });
  }
}
