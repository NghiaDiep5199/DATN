import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/providers/cart_provider.dart';
import 'package:ecommerce_customer_app/providers/stripe_id.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_customer_app/widgets/blue_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  const PaymentScreen(
      {super.key,
      required this.name,
      required this.phone,
      required this.address});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  final dateTime = DateTime.now();
  int step = 0;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 60, msg: 'Please wait...', progressBgColor: Colors.yellow);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    int? totalProduct = context.watch<Cart>().totalProduct;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.white,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(
                      title: 'Payment',
                    ),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 65),
                    child: Column(
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Sedan',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${totalPaid.toStringAsFixed(2)} USD',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Acme',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.lightBlueAccent,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total orders:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Sedan',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Acme',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total items: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Sedan',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${totalProduct} items',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Acme',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shiping coast:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Sedan',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '10.00 USD',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Acme',
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                            child: Column(
                              children: [
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                    print(selectedValue);
                                  },
                                  title: Text(
                                    'Cash On Delivery',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sedan',
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Pay cash at home',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sedan',
                                    ),
                                  ),
                                ),
                                RadioListTile(
                                    value: 2,
                                    groupValue: selectedValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                      print(selectedValue);
                                    },
                                    title: Text(
                                      'Pay Vi Visa / Master Card',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Sedan',
                                      ),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          Icons.payment,
                                          color: Colors.lightBlue,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            FontAwesomeIcons.ccMastercard,
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: Colors.lightBlue,
                                        ),
                                      ],
                                    )),
                                RadioListTile(
                                  value: 3,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                    print(selectedValue);
                                  },
                                  title: Text(
                                    'Pay Via Paypal',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sedan',
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.ccPaypal,
                                        color: Colors.lightBlue,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons.paypal,
                                          color: Colors.lightBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18, left: 18, bottom: 10),
                      child: BlueButton(
                        label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                        width: 1,
                        onPressed: () async {
                          if (selectedValue == 1) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Pay AT Home \$ ${totalPaid.toStringAsFixed(2)} ',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sedan',
                                            ),
                                          ),
                                          BlueButton(
                                              label:
                                                  'Confirm \$ ${totalPaid.toStringAsFixed(2)} ',
                                              onPressed: () async {
                                                showProgress();
                                                for (var item in context
                                                    .read<Cart>()
                                                    .getItems) {
                                                  CollectionReference orderRef =
                                                      FirebaseFirestore.instance
                                                          .collection('orders');
                                                  orderId = const Uuid().v4();
                                                  await orderRef
                                                      .doc(orderId)
                                                      .set({
                                                    'cid': data['cid'],
                                                    'custname': widget.name,
                                                    'email': data['email'],
                                                    'address': widget.address,
                                                    'phone': widget.phone,
                                                    'profileimage':
                                                        data['profileimage'],
                                                    'sid': item.suppId,
                                                    'proid': item.documentId,
                                                    'orderid': orderId,
                                                    'ordername': item.name,
                                                    'orderimage':
                                                        item.imagesUrl.first,
                                                    'orderqty': item.qty,
                                                    'orderprice':
                                                        item.qty * item.price,
                                                    'deliverystatus':
                                                        'preparing',
                                                    'deliverydate': '',
                                                    'orderdate': DateTime.now(),
                                                    'paymentstatus':
                                                        'cash on delivery',
                                                    'orderreview': false,
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
                                                                  'products')
                                                              .doc(item
                                                                  .documentId);
                                                      DocumentSnapshot
                                                          snapshot2 =
                                                          await transaction.get(
                                                              documentReference);
                                                      transaction.update(
                                                          documentReference, {
                                                        'instock': snapshot2[
                                                                'instock'] -
                                                            item.qty
                                                      });
                                                    });
                                                  });
                                                }

                                                await Future.delayed(
                                                        const Duration(
                                                            microseconds: 100))
                                                    .whenComplete(() {
                                                  context
                                                      .read<Cart>()
                                                      .clearCart();
                                                  Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        '/customer_screen'),
                                                  );
                                                });
                                              },
                                              width: 0.8)
                                        ],
                                      ),
                                    ));
                          } else if (selectedValue == 2) {
                            int payment = totalPaid.round();
                            int pay = payment * 100;

                            await makePayment(data, pay.toString());
                          } else if (selectedValue == 3) {
                            print('paypal');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(dynamic data, String total) async {
    try {
      paymentIntentData = await createPaymentIntent(total, 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'ANNIE',
        ),
      );

      await displayPaymentSheet(data);
    } catch (e) {
      print('exception:$e');
    }
  }

  displayPaymentSheet(dynamic data) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        paymentIntentData = null;
        print('paid');

        showProgress();
        for (var item in context.read<Cart>().getItems) {
          CollectionReference orderRef =
              FirebaseFirestore.instance.collection('orders');
          orderId = const Uuid().v4();
          await orderRef.doc(orderId).set({
            'cid': data['cid'],
            'custname': data['name'],
            'email': data['email'],
            'address': data['address'],
            'phone': data['phone'],
            'profileimage': data['profileimage'],
            'sid': item.suppId,
            'proid': item.documentId,
            'orderid': orderId,
            'ordername': item.name,
            'orderimage': item.imagesUrl.first,
            'orderqty': item.qty,
            'orderprice': item.qty * item.price,
            'deliverystatus': 'preparing',
            'deliverydate': '',
            'orderdate': DateTime.now(),
            'paymentstatus': 'paid online',
            'orderreview': false,
          }).whenComplete(() async {
            await FirebaseFirestore.instance
                .runTransaction((transaction) async {
              DocumentReference documentReference = FirebaseFirestore.instance
                  .collection('products')
                  .doc(item.documentId);
              DocumentSnapshot snapshot2 =
                  await transaction.get(documentReference);
              transaction.update(documentReference,
                  {'instock': snapshot2['instock'] - item.qty});
            });
          });
        }
        await Future.delayed(const Duration(microseconds: 100))
            .whenComplete(() {
          context.read<Cart>().clearCart();
          Navigator.popUntil(context, ModalRoute.withName('/customer_screen'));
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntent(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      print(e.toString());
    }
  }
}
