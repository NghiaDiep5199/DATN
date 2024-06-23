import 'package:ecommerce_customer_app/main_screens/home.dart';
import 'package:ecommerce_customer_app/minor_screens/order_details/cancelled_orders.dart';
import 'package:ecommerce_customer_app/minor_screens/order_details/delivered_orders.dart';
import 'package:ecommerce_customer_app/minor_screens/order_details/preparing_orders.dart';
import 'package:ecommerce_customer_app/minor_screens/order_details/returned_orders.dart';
import 'package:ecommerce_customer_app/minor_screens/order_details/shipping_orders.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:flutter/material.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Orders'),
          leading: const AppBarBackButton(),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            indicatorWeight: 1,
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
