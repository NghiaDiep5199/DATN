import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/models/product_model.dart';
import 'package:ecommerce_customer_app/providers/id_provider.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({super.key, required this.suppId});

  @override
  _VisitStoreState createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  String customerId = '';

  List<String> subcriptionsList = [];

  checkUserSubscription() {
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        subcriptionsList.add(doc['customerid']);
      }
    }).whenComplete(() {
      following = subcriptionsList.contains(context.read<IdProvider>().getData);
    });
  }

  subscribeToTopic() {
    FirebaseMessaging.instance.subscribeToTopic('${widget.suppId}store');
    String id = context.read<IdProvider>().getData;
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .doc(id)
        .set({'customerid': id});
    setState(() {
      following = true;
    });
  }

  unsubscribeFromTopic() {
    FirebaseMessaging.instance.unsubscribeFromTopic('${widget.suppId}store');
    String id = context.read<IdProvider>().getData;
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .doc(id)
        .delete();

    setState(() {
      following = false;
    });
  }

  @override
  void initState() {
    customerId == '' ? null : checkUserSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> _prodcutsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
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
          return Scaffold(
            backgroundColor: Colors.blue.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              flexibleSpace: data['coverimage'] == ''
                  ? Image.asset(
                      'images/inapp/storecover.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      data['coverimage'],
                      fit: BoxFit.cover,
                    ),
              leading: const BlueBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.yellow),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['storename'].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.yellow,
                                  fontFamily: 'Sedan',
                                ),
                              ),
                            ),
                          ],
                        ),
                        /* data['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    border: Border.all(
                                        width: 3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
                                child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditStore(
                                            data: data,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Text(
                                          'Edit',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontFamily: 'Sedan',
                                          ),
                                        ),
                                        Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        )
                                      ],
                                    )))
                            : */
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _prodcutsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                    'This Store \n\n has no items yet !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5),
                  ));
                }

                return SingleChildScrollView(
                  child: StaggeredGridView.countBuilder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        return ProductModel(
                          products: snapshot.data!.docs[index],
                        );
                      },
                      staggeredTileBuilder: (context) =>
                          const StaggeredTile.fit(1)),
                );
              },
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
