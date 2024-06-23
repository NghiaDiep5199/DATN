import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/customer_screens/add_address.dart';
import 'package:ecommerce_customer_app/customer_screens/address_book.dart';
import 'package:ecommerce_customer_app/minor_screens/payment_screen.dart';
import 'package:ecommerce_customer_app/providers/cart_provider.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_customer_app/widgets/blue_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .where('default', isEqualTo: true)
      .limit(1)
      .snapshots();
  late String name;
  late String phone;
  late String address;

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    return StreamBuilder<QuerySnapshot>(
        stream: addressStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // if (snapshot.data!.docs.isEmpty) {
          //   return const Center(
          //       child: Text(
          //     'This category \n\n has no items yet !',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontSize: 26,
          //         color: Colors.blueGrey,
          //         fontWeight: FontWeight.bold,
          //         fontFamily: 'Sedan',
          //         letterSpacing: 1.5),
          //   ));
          // }

          return Material(
            color: Colors.white,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.blue[100],
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: const AppBarBackButton(),
                  title: const AppBarTitle(
                    title: 'Place Order',
                  ),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 65),
                  child: Column(
                    children: [
                      snapshot.data!.docs.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddAddress(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Set your address',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Sedan',
                                          letterSpacing: 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddressBook(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15)),
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var customer = snapshot.data!.docs[index];
                                    name = customer['firstname'] +
                                        customer['lastname'];
                                    phone = customer['phone'];
                                    address = customer['addressdetail'] +
                                        ',' +
                                        customer['state'] +
                                        ',' +
                                        customer['city'] +
                                        ' ,' +
                                        customer['country'];
                                    return ListTile(
                                      title: SizedBox(
                                        height: 50,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${customer['firstname']} ${customer['lastname']}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Sedan',
                                                  letterSpacing: 1.5),
                                            ),
                                            Text(customer['phone']),
                                          ],
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'City/state:  ${customer['city']}, ${customer['state']}, ${customer['country']}'),
                                          Text(
                                              'Address details:  ${customer['addressdetail']}'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: Consumer<Cart>(
                            builder: (context, cart, child) {
                              return ListView.builder(
                                  itemCount: cart.count,
                                  itemBuilder: (context, index) {
                                    final order = cart.getItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15)),
                                              child: SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                    order.imagesUrl.first),
                                              ),
                                            ),
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    order.name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontFamily: 'Sedan',
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '\$ ' +
                                                              order.price
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontFamily: 'Acme',
                                                          ),
                                                        ),
                                                        Text(
                                                          'x ${order.qty.toString()}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontFamily: 'Acme',
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: Container(
                  color: Colors.blue[100],
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 18, left: 18, bottom: 10),
                    child: BlueButton(
                      label: 'Confirm ${totalPrice.toStringAsFixed(2)} USD',
                      width: 1,
                      onPressed: snapshot.data!.docs.isEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddAddress(),
                                ),
                              );
                            }
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    name: name,
                                    phone: phone,
                                    address: address,
                                  ),
                                ),
                              );
                            },
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
