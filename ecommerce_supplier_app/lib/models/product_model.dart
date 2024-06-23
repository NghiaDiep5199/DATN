import 'package:ecommerce_supplier_app/minor_screens/edit_product.dart';
import 'package:ecommerce_supplier_app/minor_screens/product_details.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({
    super.key,
    required this.products,
  });

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              proList: widget.products,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxHeight: 250,
                      ),
                      child: Image(
                          image: NetworkImage(widget.products['proimages'][0])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.products['proname'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                          ),
                        ),
                        Padding(
                          padding: widget.products['sid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? const EdgeInsets.all(0)
                              : const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '\$ ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onSale != 0
                                      ? Text(
                                          ((1 - (onSale / 100)) *
                                                  widget.products['price'])
                                              .toStringAsFixed(2),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const Text(''),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.products['price'].toStringAsFixed(2),
                                    style: onSale != 0
                                        ? const TextStyle(
                                            fontSize: 9,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.lineThrough,
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
                              widget.products['sid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditProduct(
                                                items: widget.products),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 10,
                    child: Container(
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Center(
                        child: Text('Save ${onSale.toString()} %    '),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  )
          ],
        ),
      ),
    );
  }
}
