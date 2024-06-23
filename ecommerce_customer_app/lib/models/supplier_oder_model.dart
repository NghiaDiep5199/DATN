import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:intl/intl.dart';

class SupplierOrderModel extends StatelessWidget {
  final dynamic order;
  const SupplierOrderModel({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.lightBlueAccent),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 70),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(order['orderimage']),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['ordername'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                            letterSpacing: 1.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(('\$') +
                              (order['orderprice'].toStringAsFixed(2))),
                          Text(('x ') + (order['orderqty'].toString())),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'See more...',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sedan',
                    letterSpacing: 1.5),
              ),
              Text(
                order['deliverystatus'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sedan',
                ),
              ),
            ],
          ),
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name: ') + (order['custname']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Text(
                      ('Phone: ') + (order['phone']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Text(
                      ('Email: ') + (order['email']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Text(
                      ('Address: ') + (order['address']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          ('Payment status: '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Text(
                          (order['paymentstatus']),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          ('Delivery status: '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Text(
                          (order['deliverystatus']),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          ('Order date: '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Text(
                          (DateFormat('yyyy-MM-dd')
                              .format(order['orderdate'].toDate())
                              .toString()),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Acme',
                          ),
                        ),
                      ],
                    ),
                    order['deliverystatus'] == 'delivered'
                        ? Center(
                            child: const Text(
                              'This order has been already delivered',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan',
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                ('Change delivery status to: '),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan',
                                ),
                              ),
                              order['deliverystatus'] == 'preparing'
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now().add(
                                              const Duration(days: 365),
                                            ), onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['orderid'])
                                              .update({
                                            'deliverystatus': 'shipping',
                                            'deliverydate': date,
                                          });
                                        });
                                      },
                                      child: const Text(
                                        'shipping',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sedan',
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.lightBlue,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order['orderid'])
                                            .update({
                                          'deliverystatus': 'delivered',
                                        });
                                      },
                                      child: const Text(
                                        'delivered',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sedan',
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.lightBlue,
                                      ),
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
