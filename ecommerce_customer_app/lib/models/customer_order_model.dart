import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/widgets/blue_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  late String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        color: Colors.white,
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
                    height: 60,
                    width: 60,
                    constraints: BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.order['orderimage']),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.order['ordername'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                            letterSpacing: 1.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(('\$') +
                              (widget.order['orderprice'].toStringAsFixed(2))),
                          Text(('x ') + (widget.order['orderqty'].toString())),
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sedan',
                    letterSpacing: 1.5),
              ),
              Text(
                widget.order['deliverystatus'],
                style: TextStyle(
                  fontSize: 14,
                  color: widget.order['deliverystatus'] == 'delivered'
                      ? Colors.green
                      : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sedan',
                ),
              ),
            ],
          ),
          children: [
            Container(
              //height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliverystatus'] == 'delivered'
                    ? Colors.green.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name: ') + (widget.order['custname']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Text(
                      ('Phone: ') + (widget.order['phone']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Text(
                      ('Email: ') + (widget.order['email']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                      ),
                    ),
                    Text(
                      ('Address: ') + (widget.order['address']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Text(
                          (widget.order['paymentstatus']),
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
                          ('Order date: '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Text(
                          (DateFormat('yyyy-MM--dd')
                                  .format(widget.order['orderdate'].toDate()))
                              .toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Text(
                          (widget.order['deliverystatus']),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.order['deliverystatus'] == 'delivered'
                            ? TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(widget.order['orderid'])
                                      .update({
                                    'deliverystatus': 'returned',
                                  });
                                },
                                child: const Text(
                                  'Returned',
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
                            : Container(),
                        widget.order['deliverystatus'] == 'preparing'
                            ? TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(widget.order['orderid'])
                                      .update({
                                    'deliverystatus': 'cancelled',
                                  });
                                },
                                child: const Text(
                                  'Cancelled',
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
                            : Container(),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                            ('Estimated delivery date: ') +
                                (DateFormat('yyyy-MM--dd').format(
                                        widget.order['deliverydate'].toDate()))
                                    .toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                            ),
                          )
                        : Container(),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Material(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 200,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RatingBar.builder(
                                                initialRating: 1,
                                                maxRating: 1,
                                                allowHalfRating: true,
                                                itemBuilder: (context, _) {
                                                  return const Icon(
                                                    Icons.star,
                                                    color: Colors.lightBlue,
                                                  );
                                                },
                                                onRatingUpdate: (value) {
                                                  rate = value;
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter your review',
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15))),
                                                  onChanged: (value) {
                                                    comment = value;
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  BlueButton(
                                                    label: 'Cancel',
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    width: 0.3,
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  BlueButton(
                                                    label: 'Yes',
                                                    onPressed: () async {
                                                      CollectionReference
                                                          collRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(widget.order[
                                                                  'proid'])
                                                              .collection(
                                                                  'reviews');

                                                      await collRef
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set({
                                                        'name': widget
                                                            .order['custname'],
                                                        'email': widget
                                                            .order['email'],
                                                        'rate': rate,
                                                        'comment': comment,
                                                        'profileimage':
                                                            widget.order[
                                                                'profileimage']
                                                      }).whenComplete(() async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (transaction) async {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'orders')
                                                                  .doc(widget
                                                                          .order[
                                                                      'orderid']);

                                                          transaction.update(
                                                              documentReference,
                                                              {
                                                                'orderreview':
                                                                    true
                                                              });
                                                        });
                                                      });
                                                      await Future.delayed(
                                                              const Duration(
                                                                  microseconds:
                                                                      100))
                                                          .whenComplete(() =>
                                                              Navigator.pop(
                                                                  context));
                                                    },
                                                    width: 0.3,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: Text(
                              'Write review now',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan',
                              ),
                            ),
                          )
                        : Container(),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.lightBlue,
                                ),
                                Text(
                                  'Review Added',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.lightBlue,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sedan',
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
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
