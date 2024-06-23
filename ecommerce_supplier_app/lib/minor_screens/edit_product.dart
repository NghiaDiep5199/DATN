// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_supplier_app/utilities/categ_list.dart';
import 'package:ecommerce_supplier_app/widgets/blue_button.dart';
import 'package:ecommerce_supplier_app/widgets/snackbar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  final dynamic items;
  const EditProduct({super.key, required this.items});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  late String proId;
  int? discount = 0;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];
  bool processing = false;

  final ImagePicker _picker = ImagePicker();

  List<XFile>? imagesFileList = [];
  List<dynamic> imagesUrlList = [];
  dynamic _pickedImageError;

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return const Center(
        child: Text('Change Images !',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      );
    }
  }

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.items['proimages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
  }

  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }

  Future uploadImages() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (imagesFileList != null && imagesFileList!.isNotEmpty) {
        try {
          for (var image in imagesFileList!) {
            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref('products/${path.basename(image.path)}');

            await ref.putFile(File(image.path)).whenComplete(() async {
              await ref.getDownloadURL().then((value) {
                imagesUrlList.add(value);
              });
            });
          }
        } catch (e) {
          print(e);
        }
      } else {
        imagesUrlList = widget.items['proimages'];
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  Future editProductData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['proid']);
      transaction.update(documentReference, {
        'maincateg': mainCategValue,
        'subcateg': subCategValue,
        'price': price,
        'instock': quantity,
        'proname': proName,
        'prodesc': proDesc,
        'proimages': imagesUrlList,
        'discount': discount,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  Future saveChanges() async {
    setState(() {
      processing = true;
    });

    await uploadImages().whenComplete(() async {
      bool isMainCategValid = mainCategValue != 'select category';
      bool isSubCategValid = subCategValue != 'subcategory';

      if (isMainCategValid && isSubCategValid) {
        await editProductData();
      } else if (mainCategValue == 'select category' &&
          subCategValue == 'subcategory') {
        mainCategValue = widget.items['maincateg'];
        subCategValue = widget.items['subcateg'];
        await editProductData();
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please select categories');
      }

      setState(() {
        processing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Colors.blueGrey.shade100,
                            height: size.width * 0.5,
                            width: size.width * 0.5,
                            child: previewCurrentImages(),
                          ),
                          SizedBox(
                            height: size.width * 0.5,
                            width: size.width * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Main category',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sedan',
                                            letterSpacing: 1.5),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        margin: const EdgeInsets.all(6),
                                        constraints: BoxConstraints(
                                            minWidth: size.width * 0.3),
                                        decoration: BoxDecoration(
                                            color: Colors.blue[100],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                          widget.items['maincateg'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sedan',
                                              letterSpacing: 1.5),
                                        )),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Subcategory',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sedan',
                                            letterSpacing: 1.5),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        margin: const EdgeInsets.all(6),
                                        constraints: BoxConstraints(
                                            minWidth: size.width * 0.3),
                                        decoration: BoxDecoration(
                                            color: Colors.blue[100],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Text(
                                          widget.items['subcateg'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sedan',
                                              letterSpacing: 1.5),
                                        )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.blue,
                    thickness: 1.5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 8, right: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue:
                              widget.items['price'].toStringAsFixed(2),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter price';
                            } else if (value.isValidPrice() != true) {
                              return 'invalid price';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = double.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Price',
                            hintText: 'Enter price .. \$',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                              letterSpacing: 1.5,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['discount'].toString(),
                          maxLength: 2,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter discount';
                            } else if (value.isValidDiscount() != true) {
                              return 'invalid discount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            discount = int.parse(value!);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Discount',
                            hintText: 'Enter discount %',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                              letterSpacing: 1.5,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['instock'].toString(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter Quantity';
                            } else if (value.isValidQuantity() != true) {
                              return 'invalid quantity';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            quantity = int.parse(value!);
                          },
                          keyboardType: TextInputType.number,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Quantity',
                            hintText: 'Enter Quantity',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                              letterSpacing: 1.5,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['proname'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            proName = value!;
                          },
                          maxLength: 100,
                          maxLines: 2,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Product name',
                            hintText: 'Enter product name',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                              letterSpacing: 1.5,
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                          initialValue: widget.items['prodesc'],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter product description';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            proDesc = value!;
                          },
                          maxLength: 800,
                          maxLines: 3,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Product description',
                            hintText: 'Enter product description',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                              letterSpacing: 1.5,
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ExpandablePanel(
                    theme: const ExpandableThemeData(hasIcon: false),
                    header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(6),
                        child: const Center(
                          child: Text(
                            'Change images and categories',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    collapsed: const SizedBox(),
                    expanded: changeImages(size),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BlueButton(
                                label: 'Cancel',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                width: 0.25),
                            processing == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ))
                                : BlueButton(
                                    label: 'Save',
                                    onPressed: () {
                                      saveChanges();
                                    },
                                    width: 0.25),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 20, bottom: 40),
                        //   child: PickButton(
                        //     label: 'Delete item',
                        //     onPressed: () async {
                        //       await FirebaseFirestore.instance
                        //           .runTransaction((transaction) async {
                        //         DocumentReference documentReference =
                        //             FirebaseFirestore.instance
                        //                 .collection('products')
                        //                 .doc(widget.items['proid']);
                        //         transaction.delete(documentReference);
                        //       }).whenComplete(() => Navigator.pop(context));
                        //     },
                        //     width: 0.65,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: processing == true
              ? null
              : () async {
                  await FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('products')
                        .doc(widget.items['proid']);
                    transaction.delete(documentReference);
                  }).whenComplete(() => Navigator.pop(context));
                },
          backgroundColor: Colors.blue,
          child: processing == true
              ? const CircularProgressIndicator(
                  color: Colors.black,
                )
              : const Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }

  Widget changeImages(Size size) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: imagesFileList!.isEmpty
                  ? () {
                      pickProductImages();
                    }
                  : () {
                      setState(() {
                        imagesFileList = [];
                      });
                    },
              child: Container(
                color: Colors.blueGrey.shade100,
                height: size.width * 0.5,
                width: size.width * 0.5,
                child: imagesFileList != null
                    ? previewImages()
                    : const Center(
                        child: Text(
                          'Please select a photo !',
                          textAlign: TextAlign.center,
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
            SizedBox(
              height: size.width * 0.5,
              width: size.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text(
                          '* Select main category',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                            letterSpacing: 1.5,
                          ),
                        ),
                        DropdownButton(
                            iconSize: 40,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            dropdownColor: Colors.blue.shade100,
                            value: mainCategValue,
                            items: maincateg
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sedan',
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              selectedMainCateg(value);
                            }),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          '* Select subcategory',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                            letterSpacing: 1.5,
                          ),
                        ),
                        DropdownButton(
                            iconSize: 40,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            dropdownColor: Colors.blue.shade100,
                            menuMaxHeight: 500,
                            disabledHint: const Text(
                              'select category',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sedan',
                                letterSpacing: 1.5,
                              ),
                            ),
                            value: subCategValue,
                            items: subCategList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sedan',
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              print(value);
                              setState(() {
                                subCategValue = value!;
                              });
                            })
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'price',
  hintText: 'price .. \$',
  labelStyle: const TextStyle(color: Colors.black),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 1),
      borderRadius: BorderRadius.circular(10)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      borderRadius: BorderRadius.circular(10)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
