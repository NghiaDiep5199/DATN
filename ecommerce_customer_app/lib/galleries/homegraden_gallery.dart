import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HomegardenGalleryScreen extends StatefulWidget {
  const HomegardenGalleryScreen({super.key});

  @override
  State<HomegardenGalleryScreen> createState() =>
      _HomegardenGalleryScreenState();
}

class _HomegardenGalleryScreenState extends State<HomegardenGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'home & garden')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
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
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
        );
      },
    );
  }
}
