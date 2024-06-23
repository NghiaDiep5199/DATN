import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_supplier_app/minor_screens/forgot_password.dart';
import 'package:ecommerce_supplier_app/providers/auth_repo.dart';
import 'package:ecommerce_supplier_app/widgets/auth_widget.dart';
import 'package:ecommerce_supplier_app/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final TextEditingController _nameController = TextEditingController();
// final TextEditingController _emailController = TextEditingController();
// final TextEditingController _passwordController = TextEditingController();

class SupplierSignin extends StatefulWidget {
  final dynamic data;
  const SupplierSignin({
    super.key,
    this.data,
  });

  @override
  State<SupplierSignin> createState() => _SupplierSigninState();
}

class _SupplierSigninState extends State<SupplierSignin> {
  late String email;
  late String password;

  bool processing = false;
  bool passwordObscured = true;
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void signIn() async {
    // await FirebaseAuth.instance.currentUser!.reload();
    // if (FirebaseAuth.instance.currentUser!.emailVerified) {

    setState(() {
      processing = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);

        _formKey.currentState!.reset();

        User user = FirebaseAuth.instance.currentUser!;
        final SharedPreferences pref = await _prefs;
        pref.setString('supplierid', user.uid);

        await Future.delayed(const Duration(milliseconds: 100))
            .whenComplete(() {
          Navigator.pushReplacementNamed(context, '/supplier_screen');
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        if (e.code == 'user-not-found') {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'No user found for that email');
        } else if (e.code == 'wrong-password') {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Wrong password provided for that user');
        } else if (e.code == 'invalid-email') {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'The email address is badly formatted');
        } else if (e.code == 'invalid-credential') {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'Email or password is incorrect');
        }
      } catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'An error occurred. Please try again');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill in all fields');
    }

    //}
    //  else {
    //   MyMessageHandler.showSnackBar(
    //       _scaffoldKey, 'Please check your inbox email');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AuthHeaderLabel(
                        headerLabel: 'Sign In Supplier',
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email.';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              // MyMessageHandler.showSnackBar(
                              //   _scaffoldKey, 'Your email is valid');
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          // controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            labelStyle: TextStyle(
                              color: Colors.blue,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          //  controller: _passwordController,
                          obscureText: passwordObscured,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            labelStyle: TextStyle(
                              color: Colors.blue,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
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
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'Don\'t have account?',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_signup');
                        },
                      ),
                      processing == true
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ))
                          : AuthMainButton(
                              mainButtonLabel: 'Sign In',
                              onPressed: () {
                                signIn();
                              },
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
