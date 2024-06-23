// ignore_for_file: avoid_print

import 'package:ecommerce_customer_app/customer_screens/add_address.dart';
import 'package:ecommerce_customer_app/providers/auth_repo.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_customer_app/widgets/blue_button.dart';
import 'package:ecommerce_customer_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool checkOldPasswordValidation = true;
  bool passwordObscured = true;
  bool passwordObscured1 = true;
  bool passwordObscured2 = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const AppBarTitle(title: 'Change password'),
            leading: const AppBarBackButton()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
            child: Form(
              key: formKey,
              child: Column(children: [
                const Text(
                  'To change your password  please fill in the form below  and click Save Changes',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.1,
                    color: Colors.blueGrey,
                    fontFamily: 'Sedan',
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                    obscureText: passwordObscured,
                    controller: oldPasswordController,
                    decoration: textFormDecoration.copyWith(
                      labelText: 'Old Password',
                      hintText: 'Enter your current password',
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordObscured = !passwordObscured;
                          });
                        },
                        icon: Icon(
                          passwordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                      errorText: checkOldPasswordValidation != true
                          ? 'not valid password'
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter new password';
                      }
                      return null;
                    },
                    obscureText: passwordObscured1,
                    controller: newPasswordController,
                    decoration: textFormDecoration.copyWith(
                      labelText: 'New password',
                      hintText: 'Enter your new password',
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordObscured1 = !passwordObscured1;
                          });
                        },
                        icon: Icon(
                          passwordObscured1
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'Password pot maching';
                      } else if (value!.isEmpty) {
                        return 'Re-Enter new password';
                      }
                      return null;
                    },
                    obscureText: passwordObscured2,
                    decoration: textFormDecoration.copyWith(
                      labelText: 'Repeat password',
                      hintText: 'Re-Enter your new password',
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordObscured2 = !passwordObscured2;
                          });
                        },
                        icon: Icon(
                          passwordObscured2
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlutterPwValidator(
                    controller: newPasswordController,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    numericCharCount: 2,
                    specialCharCount: 1,
                    width: 400,
                    height: 150,
                    onSuccess: () {},
                    onFail: () {}),
                const Spacer(),
                BlueButton(
                  label: 'Save changes',
                  onPressed: () async {
                    print(FirebaseAuth.instance.currentUser);
                    if (formKey.currentState!.validate()) {
                      checkOldPasswordValidation =
                          await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email!,
                              oldPasswordController.text);
                      setState(() {});
                      checkOldPasswordValidation == true
                          ? await AuthRepo.updateUserPassword(
                                  newPasswordController.text.trim())
                              .whenComplete(() {
                              formKey.currentState!.reset();
                              oldPasswordController.clear();
                              newPasswordController.clear();

                              MyMessageSuccessful.showSucSnackBar(scaffoldKey,
                                  'Your password has been updated');
                              Future.delayed(const Duration(seconds: 3))
                                  .whenComplete(() => Navigator.pop(context));
                            })
                          : print('not valid old password');
                      print('form valid');
                    } else {
                      print('form not valid');
                    }
                  },
                  width: 0.7,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

var passwordFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 1),
      borderRadius: BorderRadius.circular(6)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      borderRadius: BorderRadius.circular(6)),
);
