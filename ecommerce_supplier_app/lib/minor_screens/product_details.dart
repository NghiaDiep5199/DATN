import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_supplier_app/minor_screens/full_screen_view.dart';
import 'package:ecommerce_supplier_app/models/product_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({
    super.key,
    required this.proList,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.proList['proid'])
      .collection('reviews')
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];

  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.lightBlue,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(
          widget.proList['proname'],
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.lightBlue,
            size: 25,
          ),
        ),
      ),
      child: Material(
        child: SafeArea(
          child: ScaffoldMessenger(
            key: _scaffoldKey,
            child: Scaffold(
              backgroundColor: Colors.blue[100],
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60, left: 5, right: 5),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreenView(
                                        imagesList: imagesList,
                                      )));
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Swiper(
                                itemBuilder: (context, index) {
                                  return Image(
                                    image: NetworkImage(
                                      imagesList[index],
                                    ),
                                  );
                                },
                                itemCount: imagesList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'USD ',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onSale != 0
                                  ? Text(
                                      ((1 - (onSale / 100)) *
                                              widget.proList['price'])
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Text(''),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.proList['price'].toStringAsFixed(2),
                                style: onSale != 0
                                    ? const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      widget.proList['instock'] == 0
                          ? Text(
                              'This item is out of stock',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Sedan',
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              (widget.proList['instock'].toString()) +
                                  ' pieces available in stock',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Sedan',
                                  fontWeight: FontWeight.bold),
                            ),
                      const ProductDetailsHeader(
                        label: '    Item Description    ',
                      ),
                      Text(
                        widget.proList['prodesc'],
                        // textScaleFactor: 1.1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Stack(children: [
                        const Positioned(
                            right: 50, top: 15, child: Text('Total')),
                        ExpandableTheme(
                            data: const ExpandableThemeData(
                                iconSize: 30, iconColor: Colors.blue),
                            child: reviews(reviewsStream)),
                      ]),
                      const ProductDetailsHeader(
                        label: '    Recommended Items   ',
                      ),
                      SizedBox(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: productsStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                  child: Text(
                                'This category \n\n has no items yet !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sedan',
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsHeader extends StatelessWidget {
  final String label;
  const ProductDetailsHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.orange,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Sedan',
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.orange,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.only(left: 30),
        child: const ProductDetailsHeader(
          label: '    Reviews    ',
        ),
      ),
      collapsed: SizedBox(
        height: 230,
        child: reviewsAll(reviewsStream),
      ),
      expanded: reviewsAll(reviewsStream));
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
            child: Text(
          'This Item \n\n has no reviews yet !',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 26,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontFamily: 'Acme',
              letterSpacing: 1.5),
        ));
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]['profileimage'])),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(snapshot2.data!.docs[index]['name']),
                    Row(
                      children: [
                        Text(snapshot2.data!.docs[index]['rate'].toString()),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        )
                      ],
                    )
                  ]),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
