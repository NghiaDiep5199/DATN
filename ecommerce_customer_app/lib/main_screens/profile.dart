import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/customer_screens/address_book.dart';
import 'package:ecommerce_customer_app/customer_screens/customer_orders.dart';
import 'package:ecommerce_customer_app/customer_screens/wishlist.dart';
import 'package:ecommerce_customer_app/main_screens/cart.dart';
import 'package:ecommerce_customer_app/minor_screens/change_password.dart';
import 'package:ecommerce_customer_app/providers/auth_repo.dart';
import 'package:ecommerce_customer_app/providers/id_provider.dart';
import 'package:ecommerce_customer_app/widgets/alert_dialog.dart';
import 'package:ecommerce_customer_app/widgets/appbar_wiget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  // final String documentId;
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String> documentId;
  late String docId;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  @override
  void initState() {
    documentId = context.read<IdProvider>().getDocumnetId();
    docId = context.read<IdProvider>().getData;

    // documentId = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString('customerid') ?? '';
    // }).then((String value) {
    //   setState(() {
    //     docId = value;
    //   });
    //   print(documentId);
    //   print(docId);
    //   return docId;
    // });

    super.initState();
  }

  String userAddress(dynamic data) {
    if (/* FirebaseAuth.instance.currentUser!.isAnonymous */ docId == '') {
      return 'example: Ho Chi Minh City';
    } else if (/* FirebaseAuth.instance.currentUser!.isAnonymous == false */ docId ==
            '' &&
        data['address'] == '') {
      return 'Set your address';
    }
    return data['address'];
  }

  void signInDialog() {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Please log in'),
        content: const Text('you should be logged in to take an action'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/customer_signin');
            },
            child: const Text('Log in'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: documentId,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Material(
                  child: Center(child: CircularProgressIndicator()));
            case ConnectionState.done:
              return docId != '' ? userScaffold() : noUserScaffold();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
          }
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        });
  }

  Widget userScaffold() {
    return FutureBuilder<DocumentSnapshot>(
      future: // FirebaseAuth.instance.currentUser!.isAnonymous
          //     ? anonymous.doc(docId).get() :
          customers.doc(docId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 265,
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.blue, Colors.yellow])),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      expandedHeight: 180,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            title: Padding(
                              padding: const EdgeInsets.only(right: 70),
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 50),
                                opacity:
                                    constraints.biggest.height <= 100 ? 1 : 0,
                                child: Text(
                                  'Proflie',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sedan',
                                  ),
                                ),
                              ),
                            ),
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.yellow],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: data['profileimage'] == ''
                                        ? const CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                                'images/inapp/guest.jpg'),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                data['profileimage']),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      data['name'] == ''
                                          ? 'guest'.toUpperCase()
                                          : data['name'].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Sedan',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow,
                                  Colors.blue,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30))),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: const Center(
                                        child: Text(
                                          'Cart',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sedan',
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(
                                            back: AppBarBackButton(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  color: Colors.black54,
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: const Center(
                                        child: Text(
                                          'Orders',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sedan',
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomerOrders(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30))),
                                  child: TextButton(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: const Center(
                                        child: Text(
                                          'Wishlist',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Sedan',
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const WishlistScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 100,
                                  child: Image(
                                      image:
                                          AssetImage('images/logostore.png')),
                                ),
                                const ProfileHeaderLabel(
                                  headerLabel: '  Account Info.  ',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                          title: 'Email Address',
                                          icon: Icons.email,
                                          subTitle: data['email'] == ''
                                              ? 'example@gmail.com'
                                              : data['email'],
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          onPressed: FirebaseAuth.instance
                                                  .currentUser!.isAnonymous
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddressBook(),
                                                    ),
                                                  );
                                                },
                                          title: 'Phone Number',
                                          icon: Icons.phone,
                                          subTitle: data['phone'] == ''
                                              ? 'Set phone number'
                                              : data['phone'],
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          onPressed: FirebaseAuth.instance
                                                  .currentUser!.isAnonymous
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddressBook(),
                                                    ),
                                                  );
                                                },
                                          title: 'Address',
                                          icon: Icons.location_pin,
                                          subTitle: userAddress(data),
                                          // data['address'] == ''
                                          //     ? 'example: 122. Newyork'
                                          //     : data['address'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                const ProfileHeaderLabel(
                                    headerLabel: '  Account Settings  '),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 170,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(
                                      children: [
                                        // RepeatedListTile(
                                        //   title: 'Edit Profile',
                                        //   subTitle: '',
                                        //   icon: Icons.edit,
                                        //   onPressed: () {},
                                        // ),
                                        // const YellowDivider(),
                                        RepeatedListTile(
                                          title: 'Change Password',
                                          icon: Icons.lock,
                                          subTitle:
                                              'Click on to change password',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangePassword(),
                                              ),
                                            );
                                          },
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                          title: 'Log Out',
                                          icon: Icons.logout,
                                          onPressed: () async {
                                            MyAlertDialog.showMyDialog(
                                                context: context,
                                                title: 'Log Out',
                                                content:
                                                    'Are you sure to log out?',
                                                tabNo: () {
                                                  Navigator.pop(context);
                                                },
                                                tabYes: () async {
                                                  await AuthRepo.logOut();

                                                  final SharedPreferences pref =
                                                      await _prefs;
                                                  pref.setString(
                                                      'customerid', '');

                                                  await Future.delayed(
                                                          const Duration(
                                                              microseconds:
                                                                  100))
                                                      .whenComplete(() {
                                                    Navigator.pop(context);
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      '/onboarding_screen',
                                                    );
                                                  });
                                                });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        );
      },
    );
  }

  Widget noUserScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Container(
            height: 305,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.yellow])),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                expandedHeight: 220,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.only(right: 70),
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 50),
                          opacity: constraints.biggest.height <= 100 ? 1 : 0,
                          child: Text(
                            'Proflie',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sedan',
                            ),
                          ),
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.yellow],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('images/inapp/guest.jpg'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Guest',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sedan',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 40,
                                width: 100,
                                child: Material(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(25),
                                  child: MaterialButton(
                                    child: Text(
                                      'Login',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/customer_signin');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow,
                            Colors.blue,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    'Cart',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sedan',
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                signInDialog();
                              },
                            ),
                          ),
                          Container(
                            color: Colors.black54,
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    'Orders',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sedan',
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                signInDialog();
                              },
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30))),
                            child: TextButton(
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    'Wishlist',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sedan',
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                signInDialog();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                            // child: Image(
                            //     image:
                            //         AssetImage('images/inapp/logo2.png')),
                          ),
                          const ProfileHeaderLabel(
                            headerLabel: '  Account Info.  ',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 260,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                children: [
                                  RepeatedListTile(
                                    title: 'Email Address',
                                    icon: Icons.email,
                                    subTitle: 'Example@gmail.com',
                                  ),
                                  const YellowDivider(),
                                  RepeatedListTile(
                                    title: 'Phone Number',
                                    icon: Icons.phone,
                                    subTitle: 'Example: + 1111 111 111',
                                  ),
                                  const YellowDivider(),
                                  RepeatedListTile(
                                    onPressed: () {
                                      signInDialog();
                                    },
                                    title: 'Address',
                                    icon: Icons.location_pin,
                                    subTitle: 'Example: New York - USA',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // const ProfileHeaderLabel(
                          //     headerLabel: '  Account Settings  '),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: Container(
                          //     height: 260,
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(16)),
                          //     child: Column(
                          //       children: [
                          //         RepeatedListTile(
                          //           title: 'Edit Profile',
                          //           icon: Icons.edit,
                          //           onPressed: () {},
                          //         ),
                          //         const YellowDivider(),
                          //         RepeatedListTile(
                          //           title: 'Change Password',
                          //           icon: Icons.lock,
                          //           onPressed: () {
                          //             signInDialog();
                          //           },
                          //         ),
                          //         const YellowDivider(),
                          //         RepeatedListTile(
                          //           title: 'Log Out',
                          //           icon: Icons.logout,
                          //           onPressed: () async {
                          //             MyAlertDialog.showMyDialog(
                          //                 context: context,
                          //                 title: 'Log Out',
                          //                 content: 'Are you sure to log out?',
                          //                 tabNo: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //                 tabYes: () async {
                          //                   await AuthRepo.logOut();
                          //                   await Future.delayed(const Duration(
                          //                           microseconds: 100))
                          //                       .whenComplete(() {
                          //                     Navigator.pop(context);
                          //                     Navigator.pushReplacementNamed(
                          //                         context,
                          //                         '/onboarding_screen');
                          //                   });
                          //                 });
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.blue,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile(
      {Key? key,
      required this.icon,
      this.onPressed,
      this.subTitle = '',
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.yellow[800],
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Sedan',
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
