import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_supplier_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_supplier_app/widgets/blue_button.dart';
import 'package:ecommerce_supplier_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({super.key, required this.data});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic _pickedImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String coverImage;
  bool processing = false;

  final ImagePicker _picker = ImagePicker();

  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickedCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileCover = pickedCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFileLogo!.path));

        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg-cover');

        await ref2.putFile(File(imageFileCover!.path));

        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        processing = true;
      });
      await uploadStoreLogo().whenComplete(() async =>
          await uploadCoverImage().whenComplete(() => editStoreData()));
    } else {
      MyMessageHandler.showSnackBar(scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BlueBackButton(),
          title: const AppBarTitle(title: 'Edit Stores'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Store Logo',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Sedan',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.data['storelogo']),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        BlueButton(
                          label: 'Change',
                          onPressed: () {
                            pickStoreLogo();
                          },
                          width: 0.25,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        imageFileLogo == null
                            ? const SizedBox(
                                height: 10,
                              )
                            : BlueButton(
                                label: 'Reset',
                                onPressed: () {
                                  setState(() {
                                    imageFileLogo = null;
                                  });
                                },
                                width: 0.25,
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    imageFileLogo == null
                        ? const SizedBox(
                            height: 10,
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(
                              File(imageFileLogo!.path),
                            ),
                          ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Cover Image',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Sedan',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.data['coverimage']),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            BlueButton(
                              label: 'Change',
                              onPressed: () {
                                pickCoverImage();
                              },
                              width: 0.25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            imageFileCover == null
                                ? const SizedBox(
                                    height: 10,
                                  )
                                : BlueButton(
                                    label: 'Reset',
                                    onPressed: () {
                                      setState(() {
                                        imageFileCover = null;
                                      });
                                    },
                                    width: 0.25,
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        imageFileCover == null
                            ? const SizedBox(
                                height: 10,
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(
                                  File(imageFileCover!.path),
                                ),
                              ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Divider(
                        color: Colors.blue,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter store name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storeName = value!;
                    },
                    initialValue: widget.data['storename'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Store name', hintText: 'Enter store name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter store phone';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'Store phone',
                        hintText: 'Enter store phone'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlueButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 0.25,
                      ),
                      processing == true
                          ? CircularProgressIndicator()
                          : BlueButton(
                              label: 'Save',
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.25,
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
