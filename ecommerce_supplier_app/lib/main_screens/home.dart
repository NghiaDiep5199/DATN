import 'package:ecommerce_supplier_app/galleries/accessories_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/bags_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/beauty_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/electronics_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/homegraden_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/homepage_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/kids_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/men_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/shoes_gallery.dart';
import 'package:ecommerce_supplier_app/galleries/women_.gallery.dart';
import 'package:ecommerce_supplier_app/widgets/fake_search.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const FakeSearch(),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            indicatorWeight: 1,
            tabAlignment: TabAlignment.start,
            tabs: [
              RepeatedTab(label: 'Home page'),
              RepeatedTab(label: 'Accessories'),
              RepeatedTab(label: 'Electronics'),
              RepeatedTab(label: 'Shoes'),
              RepeatedTab(label: 'Bags'),
              RepeatedTab(label: 'Men'),
              RepeatedTab(label: 'Women'),
              RepeatedTab(label: 'Kids'),
              RepeatedTab(label: 'Beauty'),
              RepeatedTab(label: 'Home & Garden'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomePageGallery(),
            AccessoriesGalleryScreen(),
            ElectronicsGalleryScreen(),
            ShoesGalleryScreen(
              fromOnBoarding: false,
            ),
            BagsGalleryScreen(),
            MenGalleryScreen(),
            WomenGalleryScreen(),
            KidsGalleryScreen(),
            BeautyGalleryScreen(),
            HomegardenGalleryScreen(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     try {
        //       dynamic conversationObject = {
        //         'appId': '1d77836ed830953841092a343bdfef08f',
        //       };
        //       dynamic result = await KommunicateFlutterPlugin.buildConversation(
        //         conversationObject,
        //       );
        //       print("Conversation builder success :" + result.toString());
        //     } on Exception catch (e) {
        //       print("Conversation build error occurred :" + e.toString());
        //     }
        //   },
        //   tooltip: 'Increment',
        //   child: ClipOval(
        //     child: Image.asset(
        //       'images/chattalk.png',
        //       fit: BoxFit.cover,
        //       width: 50,
        //       height: 50,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          fontFamily: 'Sedan',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
