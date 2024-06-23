import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_customer_app/widgets/blue_button.dart';
import 'package:ecommerce_customer_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String firstName;
  late String lastName;
  late String phone;
  late String addressDetail;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
          title: const AppBarTitle(title: 'Add Address'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Contact information',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan',
                                  letterSpacing: 1.5),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                firstName = value!;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'First name',
                                hintText: 'Enter  your first name',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                lastName = value!;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Last name',
                                hintText: 'Enter  your last name',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                phone = value!;
                              },
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Phone number',
                                hintText: 'Enter  your phone number',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Address information',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sedan',
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your address other details';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            addressDetail = value!;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Address other details',
                            hintText: 'Enter  your address other details',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 95),
                    child: Center(
                      child: BlueButton(
                          label: 'Save new address',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (countryValue != 'Choose Country' &&
                                  stateValue != 'Choose State' &&
                                  cityValue != 'Choose City') {
                                formKey.currentState!.save();
                                CollectionReference addressRef =
                                    await FirebaseFirestore.instance
                                        .collection('customers')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection('address');
                                var addressId = Uuid().v4();
                                await addressRef.doc(addressId).set({
                                  'addressid': addressId,
                                  'firstname': firstName,
                                  'lastname': lastName,
                                  'phone': phone,
                                  'country': countryValue,
                                  'state': stateValue,
                                  'city': cityValue,
                                  'addressdetail': addressDetail,
                                  'default': true,
                                }).whenComplete(() => Navigator.pop(context));
                              } else {
                                MyMessageHandler.showSnackBar(
                                    scaffoldKey, 'please set your location');
                              }
                            } else {
                              MyMessageHandler.showSnackBar(
                                  scaffoldKey, 'please fill all fields');
                            }
                          },
                          width: 0.6),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blue, width: 1),
    borderRadius: BorderRadius.circular(20),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blue, width: 2),
    borderRadius: BorderRadius.circular(20),
  ),
);
