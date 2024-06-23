// ignore_for_file: avoid_print
import 'package:ecommerce_supplier_app/providers/auth_repo.dart';
import 'package:ecommerce_supplier_app/widgets/appbar_wiget.dart';
import 'package:ecommerce_supplier_app/widgets/auth_widget.dart';
import 'package:ecommerce_supplier_app/widgets/blue_button.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const AppBarTitle(
            title: 'Forgot password ?',
          )),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email address',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'Sedan'),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your email ';
                    } else if (!value.isValidEmailAddress()) {
                      return 'invalid email';
                    } else if (value.isValidEmailAddress()) {
                      return null;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: textFormDecoration.copyWith(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    labelStyle: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              BlueButton(
                  label: 'Send Reset Password Link',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      AuthRepo.sendPasswordResetEmail(emailController.text);
                    } else {
                      print('form not valid');
                    }
                  },
                  width: 0.7),
            ],
          ),
        ),
      )),
    );
  }
}

var emailFormDecoration = InputDecoration(
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

extension EmailValidator on String {
  bool isValidEmailAddress() {
    return RegExp(
            r'^([a-zA-Z0-9]+)([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        .hasMatch(this);
  }
}
