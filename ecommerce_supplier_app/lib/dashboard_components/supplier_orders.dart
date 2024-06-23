import 'package:ecommerce_supplier_app/dashboard_components/dashboard_orders/cancelled_orders.dart';
import 'package:ecommerce_supplier_app/dashboard_components/dashboard_orders/delivered_orders.dart';
import 'package:ecommerce_supplier_app/dashboard_components/dashboard_orders/preparing_orders.dart';
import 'package:ecommerce_supplier_app/dashboard_components/dashboard_orders/returned_orders.dart';
import 'package:ecommerce_supplier_app/dashboard_components/dashboard_orders/shipping_orders.dart';
import 'package:ecommerce_supplier_app/main_screens/home.dart';
import 'package:ecommerce_supplier_app/widgets/appbar_wiget.dart';
import 'package:flutter/material.dart';

class SupplierOrder extends StatelessWidget {
  const SupplierOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Orders'),
          leading: BlueBackButton(),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 1,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              RepeatedTab(label: 'Preparing'),
              RepeatedTab(label: 'Shiping'),
              RepeatedTab(label: 'Delivered'),
              RepeatedTab(label: 'Returned'),
              RepeatedTab(label: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(children: [
          PreparingScreen(),
          ShippingScreen(),
          DeliveredScreen(),
          ReturnedScreen(),
          CancelledScreen(),
        ]),
      ),
    );
  }
}
