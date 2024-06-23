import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer_app/galleries/shoes_gallery.dart';
import 'package:ecommerce_customer_app/minor_screens/hot_deals.dart';
import 'package:ecommerce_customer_app/minor_screens/subcateg_products.dart';
import 'package:ecommerce_customer_app/providers/id_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Offer {
  watches,
  shoes,
  sale,
}

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen>
    with SingleTickerProviderStateMixin {
  Timer? countDowntimer;
  int seconds = 5;
  List<int> discountList = [];
  int? maxDiscount;
  late int selectedIndex;
  late String offerName;
  late String assetName;
  late Offer offer;
  late AnimationController _animationController;
  late Animation<Color?> _colorTweenAnimation;

  @override
  void initState() {
    selectRandomOffer();
    startTimer();
    getDiscount();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _colorTweenAnimation = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat();
    context.read<IdProvider>().getDocId();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectRandomOffer() {
    // [1= watches , 2= shoes , 3=sale]

    for (var i = 0; i < Offer.values.length; i++) {
      var random = Random();
      setState(() {
        selectedIndex = random.nextInt(3);
        offerName = Offer.values[selectedIndex].toString();
        assetName = offerName.replaceAll("Offer.", "");
        offer = Offer.values[selectedIndex];
      });
    }
    print(selectedIndex);
    print(offerName);
    print(assetName);
  }

  void startTimer() {
    countDowntimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        Navigator.pushReplacementNamed(context, '/customer_screen');
      }
      //   print(timer.tick);
      //   print(seconds);
    });
  }

  void stopTimer() {
    countDowntimer!.cancel();
  }

  Widget buildAsset() {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'images/onboard/ads.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void navigateToOffer() {
    switch (offer) {
      case Offer.watches:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const SubCategProducts(
                    fromOnBoarding: true,
                    subcategName: 'smart watch',
                    maincategName: 'electronics')),
            (Route route) => false);
        break;
      case Offer.shoes:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const ShoesGalleryScreen(
                      fromOnBoarding: true,
                    )),
            (Route route) => false);
        break;
      case Offer.sale:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HotDealsScreen(
                      fromOnBoarding: true,
                      maxDiscount: maxDiscount!.toString(),
                    )),
            (Route route) => false);
        break;
    }
  }

  void getDiscount() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        discountList.add(doc['discount']);
      }
    }).whenComplete(
      () => setState(
        () {
          maxDiscount = discountList.reduce(max);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              stopTimer();
              navigateToOffer();
            },
            child: buildAsset(),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                onPressed: () {
                  stopTimer();
                  Navigator.pushReplacementNamed(context, '/customer_screen');
                },
                child:
                    seconds < 1 ? const Text('Skip') : Text('Skip | $seconds'),
              ),
            ),
          ),
          offer == Offer.sale
              ? Positioned(
                  top: 565,
                  right: 130,
                  child: AnimatedOpacity(
                    duration: const Duration(microseconds: 100),
                    opacity: _animationController.value,
                    child: TextWithOutline(
                      text: maxDiscount.toString() + '%',
                      textColor: Colors.redAccent,
                      outlineColor: Colors.white,
                      outlineWidth: 10,
                      fontSize: 70,
                      fontFamily: 'Sedan',
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            bottom: 70,
            child: AnimatedBuilder(
              animation: _animationController.view,
              builder: (context, child) {
                return Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: _colorTweenAnimation.value,
                  child: child,
                );
              },
              child: const Center(
                child: Text(
                  'SHOP NOW',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TextWithOutline extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color outlineColor;
  final double outlineWidth;
  final double fontSize;
  final String fontFamily;

  TextWithOutline({
    required this.text,
    required this.textColor,
    required this.outlineColor,
    required this.outlineWidth,
    required this.fontSize,
    required this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
