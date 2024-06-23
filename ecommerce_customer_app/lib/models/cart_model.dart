import 'package:ecommerce_customer_app/providers/cart_provider.dart';
import 'package:ecommerce_customer_app/providers/product_class.dart';
import 'package:ecommerce_customer_app/providers/wish_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatefulWidget {
  const CartModel({
    super.key,
    required this.product,
    required this.cart,
  });

  final Product product;
  final Cart cart;

  @override
  State<CartModel> createState() => _CartModelState();
}

class _CartModelState extends State<CartModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          child: SizedBox(
        height: 100,
        child: Row(
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child: Image.network(widget.product.imagesUrl.first),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 260,
                          child: Text(
                            widget.product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Sedan',
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Checkbox(
                        //       value: _isChecked,
                        //       onChanged: (bool? value) {
                        //         setState(() {
                        //           _isChecked = value ?? false;
                        //         });
                        //       }),
                        // ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.price.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              widget.product.qty == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoActionSheet(
                                            title: const Text(
                                              'RemoveItem',
                                              style: TextStyle(
                                                fontFamily: 'Sedan',
                                              ),
                                            ),
                                            message: const Text(
                                              'Are you sure to remove this item ?',
                                              style: TextStyle(
                                                fontFamily: 'Sedan',
                                              ),
                                            ),
                                            actions: <CupertinoActionSheetAction>[
                                              CupertinoActionSheetAction(
                                                  child: const Text(
                                                    'Move To Wishlist',
                                                    style: TextStyle(
                                                      fontFamily: 'Sedan',
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    context
                                                                .read<Wish>()
                                                                .getWishItems
                                                                .firstWhereOrNull((element) =>
                                                                    element.documentId ==
                                                                    widget
                                                                        .product
                                                                        .documentId) !=
                                                            null
                                                        ? context
                                                            .read<Cart>()
                                                            .removeItem(
                                                                widget.product)
                                                        : await context
                                                            .read<Wish>()
                                                            .addWishItem(
                                                                widget.product
                                                                    .name,
                                                                widget.product
                                                                    .price,
                                                                1,
                                                                widget.product
                                                                    .qntty,
                                                                widget.product
                                                                    .imagesUrl,
                                                                widget.product
                                                                    .documentId,
                                                                widget.product
                                                                    .suppId);
                                                    context
                                                        .read<Cart>()
                                                        .removeItem(
                                                            widget.product);
                                                    Navigator.pop(context);
                                                  }),
                                              CupertinoActionSheetAction(
                                                child: const Text(
                                                  'Delete Item',
                                                  style: TextStyle(
                                                    fontFamily: 'Sedan',
                                                  ),
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<Cart>()
                                                      .removeItem(
                                                          widget.product);
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                            cancelButton: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.red,
                                                      fontFamily: 'Sedan',
                                                    ))),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 18,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        widget.cart.reduceByOne(widget.product);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.minus,
                                        size: 18,
                                      )),
                              Text(
                                widget.product.qty.toString(),
                                style:
                                    widget.product.qty == widget.product.qntty
                                        ? const TextStyle(
                                            fontSize: 20, color: Colors.red)
                                        : const TextStyle(
                                            fontSize: 20,
                                          ),
                              ),
                              IconButton(
                                  onPressed: widget.product.qty ==
                                          widget.product.qntty
                                      ? null
                                      : () {
                                          widget.cart.increment(widget.product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 18,
                                  ))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
