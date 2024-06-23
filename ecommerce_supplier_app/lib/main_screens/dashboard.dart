import 'package:ecommerce_supplier_app/dashboard_components/manage_products.dart';
import 'package:ecommerce_supplier_app/dashboard_components/supplier_balance.dart';
import 'package:ecommerce_supplier_app/dashboard_components/supplier_orders.dart';
import 'package:ecommerce_supplier_app/dashboard_components/supplier_static.dart';
import 'package:ecommerce_supplier_app/main_screens/visit_store.dart';
import 'package:ecommerce_supplier_app/providers/auth_repo.dart';
import 'package:ecommerce_supplier_app/widgets/alert_dialog.dart';
import 'package:ecommerce_supplier_app/widgets/appbar_wiget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> label = [
  'My Store',
  'Orders',
  'Manage',
  'Statics',
  'Balance',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.settings,
  Icons.show_chart,
];

List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  SupplierOrder(),
  ManageProducts(),
  SupplierStatic(),
];

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({super.key});
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () {
              MyAlertDialog.showMyDialog(
                  context: context,
                  title: 'Log Out',
                  content: 'Are you sure to log out?',
                  tabNo: () {
                    Navigator.pop(context);
                  },
                  tabYes: () async {
                    await AuthRepo.logOut();
                    final SharedPreferences pref = await _prefs;
                    pref.setString('supplierid', '');
                    await Future.delayed(const Duration(microseconds: 100))
                        .whenComplete(() {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, '/supplier_signin');
                    });
                  });
            },
            icon: Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          crossAxisCount: 2,
          children: List.generate(4, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black,
                    color: Colors.blueAccent.withOpacity(0.7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[index],
                          size: 50,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      label[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Sedan',
                        letterSpacing: 2,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
