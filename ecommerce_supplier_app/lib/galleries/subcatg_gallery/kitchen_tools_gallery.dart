import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_supplier_app/models/product_model.dart';
import 'package:ecommerce_supplier_app/widgets/appbar_wiget.dart';

import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class KitchenToolsGalleryScreen extends StatefulWidget {
  const KitchenToolsGalleryScreen({super.key});

  @override
  State<KitchenToolsGalleryScreen> createState() =>
      _KitchenToolsGalleryScreenState();
}

class _KitchenToolsGalleryScreenState extends State<KitchenToolsGalleryScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg')
      .where('subcateg', isEqualTo: 'kitchen tools')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: AppBarTitle(title: 'Kitchen tools'),
        leading: AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
      ),
    );
  }
}
