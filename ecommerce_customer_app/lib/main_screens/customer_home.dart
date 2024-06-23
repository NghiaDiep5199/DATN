import 'package:badges/badges.dart';
import 'package:ecommerce_customer_app/main_screens/cart.dart';
import 'package:ecommerce_customer_app/main_screens/category.dart';
import 'package:ecommerce_customer_app/main_screens/home.dart';
import 'package:ecommerce_customer_app/main_screens/profile.dart';
import 'package:ecommerce_customer_app/main_screens/stores.dart';
import 'package:ecommerce_customer_app/minor_screens/visit_store.dart';
import 'package:ecommerce_customer_app/providers/cart_provider.dart';
import 'package:ecommerce_customer_app/services/notifications_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _tabs;

  displayForegroundNotification() {
    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Customer App ===> Got a message whilst in the foreground!');
      print('Customer App ===> Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Customer App ===> Message also contained a notification: ${message.notification}');
        NotificationsServices.displayNotification(message);
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'store') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const VisitStore(suppId: 'MebITlmJAuc9MYv17dtxMHqGMRm1'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabs = [
      const HomeScreen(),
      const CaterogyScreen(),
      const StoresScreen(),
      const CartScreen(),
      const ProfileScreen(
          // documentId: FirebaseAuth.instance.currentUser!.uid,
          ),
    ];
    FirebaseMessaging.instance
        .getToken()
        .then((value) => print('Token: $value'));

    displayForegroundNotification();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
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
              showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
              badgeStyle: BadgeStyle(badgeColor: Colors.blue),
              badgeContent: Text(
                context.watch<Cart>().getItems.length.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            title: Text(
              "Cart",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Sedan',
              ),
            ),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text(
              "Profile",
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
      //  BottomNavigationBar(
      //   elevation: 0,
      //   type: BottomNavigationBarType.fixed,
      //   selectedLabelStyle: const TextStyle(
      //     fontWeight: FontWeight.w600,
      //     fontFamily: 'Sedan',
      //   ),
      //   selectedItemColor: Colors.blue,
      //   currentIndex: _selectedIndex,
      //   items: [
      //     const BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     const BottomNavigationBarItem(
      //       icon: Icon(Icons.category),
      //       label: 'Category',
      //     ),
      //     const BottomNavigationBarItem(
      //       icon: Icon(Icons.shop),
      //       label: 'Stores',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Badge(
      //         showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
      //         badgeStyle: BadgeStyle(badgeColor: Colors.blue),
      //         badgeContent: Text(
      //           context.watch<Cart>().getItems.length.toString(),
      //           style: const TextStyle(
      //             fontSize: 14,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         child: const Icon(Icons.shopping_cart),
      //       ),
      //       label: 'Cart',
      //     ),
      //     const BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
