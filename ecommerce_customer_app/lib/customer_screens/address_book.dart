import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/customer_screens/add_address.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_customer_app/widgets/blue_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('address')
      .snapshots();

  Future dfAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference docReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(item.id);
      transaction.update(docReference, {'default': false});
    });
  }

  Future dfAddressTrue(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference docReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('address')
          .doc(customer['addressid']);
      transaction.update(docReference, {'default': true});
    });
  }

  Future updateProfile(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference docReference = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(docReference, {
        'address':
            '${customer['addressdetail']} ,${customer['state']} ,${customer['city']} ,${customer['country']}',
        'phone': customer['phone']
      });
    });
  }

  // void showProgress() {
  //   ProgressDialog progressDialog = ProgressDialog(context: context);
  //   progressDialog.show(
  //       max: 60, msg: 'Please wait...', progressBgColor: Colors.yellow);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(title: 'Your Address'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: addressStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text(
                      'You have set  \n\n an address yet !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sedan',
                        letterSpacing: 1.5,
                      ),
                    ));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var customer = snapshot.data!.docs[index];
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async =>
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('customers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('address')
                                  .doc(customer['addressid']);
                          transaction.delete(documentReference);
                        }),
                        child: GestureDetector(
                          onTap: () async {
                            // showProgress();
                            for (var item in snapshot.data!.docs) {
                              await dfAddressFalse(item);
                            }
                            await dfAddressTrue(customer)
                                .whenComplete(() => updateProfile(customer));
                            // Future.delayed(const Duration(microseconds: 50))
                            //     .whenComplete(() => Navigator.pop(context));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: customer['default'] == true
                                  ? Colors.blue[300]
                                  : Colors.white,
                              child: ListTile(
                                trailing: customer['default'] == true
                                    ? const Icon(
                                        Icons.home,
                                        color: Colors.black,
                                      )
                                    : const SizedBox(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'City/state:  ${customer['city']} ${customer['state']}'),
                                    Text('Country:  ${customer['country']}'),
                                    Text(
                                        'Address details:  ${customer['addressdetail']}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: BlueButton(
                  label: 'Add new address',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddress(),
                      ),
                    );
                  },
                  width: 0.6),
            )
          ],
        ),
      ),
    );
  }
}
