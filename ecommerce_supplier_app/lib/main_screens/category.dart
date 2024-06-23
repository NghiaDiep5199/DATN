import 'package:ecommerce_supplier_app/categories/accessories_category.dart';
import 'package:ecommerce_supplier_app/categories/bags_category.dart';
import 'package:ecommerce_supplier_app/categories/beauty_category.dart';
import 'package:ecommerce_supplier_app/categories/electronics_category.dart';
import 'package:ecommerce_supplier_app/categories/home_garden_category.dart';
import 'package:ecommerce_supplier_app/categories/kids_category.dart';
import 'package:ecommerce_supplier_app/categories/men_category.dart';
import 'package:ecommerce_supplier_app/categories/shoes_category.dart';
import 'package:ecommerce_supplier_app/categories/women_category.dart';
import 'package:ecommerce_supplier_app/widgets/fake_search.dart';
import 'package:flutter/material.dart';

List<ItemsData> items = [
  ItemsData(label: 'Men'),
  ItemsData(label: 'Women'),
  ItemsData(label: 'Shoes'),
  ItemsData(label: 'Bags'),
  ItemsData(label: 'Kids'),
  ItemsData(label: 'Beauty'),
  ItemsData(label: 'Accessories'),
  ItemsData(label: 'Electronics'),
  ItemsData(label: 'Home & Garden'),
];

class CaterogyScreen extends StatefulWidget {
  const CaterogyScreen({super.key});

  @override
  State<CaterogyScreen> createState() => _CaterogyScreenState();
}

class _CaterogyScreenState extends State<CaterogyScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Men',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        MenCatagory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Women',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        WomenCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Shoes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        ShoesCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Bags',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        BagsCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Kids',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        KidsCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Beauty',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        BeautyCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Accessories',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        AccessoriesCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Electronics',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        ElectronicsCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  constraints: const BoxConstraints(maxHeight: 70),
                  width: double.infinity,
                  child: Text(
                    'Home and garden',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                children: [
                  Container(
                    height: size.height * 0.58,
                    color: Colors.white,
                    child: PageView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        HomeGardenCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget sideNavigator(Size size) {
  //   return SizedBox(
  //     height: size.height * 0.82,
  //     width: size.width * 0.23,
  //     child: ListView.builder(
  //         itemCount: items.length,
  //         itemBuilder: (context, index) {
  //           return GestureDetector(
  //             onTap: () {
  //               _pageController.animateToPage(index,
  //                   duration: const Duration(milliseconds: 100),
  //                   curve: Curves.bounceInOut);
  //             },
  //             child: Container(
  //               height: 100,
  //               color: items[index].isSeleccted == true
  //                   ? Colors.white
  //                   : Colors.blue.shade200,
  //               child: Center(
  //                 child: Text(
  //                   items[index].label,
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w700,
  //                     fontFamily: 'Sedan',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  // Widget categoryView(Size size) {
  //   return Container(
  //     height: size.height * 0.82,
  //     width: size.width * 0.77,
  //     color: Colors.white,
  //     child: PageView(
  //       controller: _pageController,
  //       onPageChanged: (value) {
  //         for (var element in items) {
  //           element.isSeleccted = false;
  //         }
  //         setState(() {
  //           items[value].isSeleccted = true;
  //         });
  //       },
  //       scrollDirection: Axis.vertical,
  //       children: const [
  //         MenCatagory(),
  //         WomenCategory(),
  //         ShoesCategory(),
  //         BagsCategory(),
  //         KidsCategory(),
  //         BeautyCategory(),
  //         AccessoriesCategory(),
  //         ElectronicsCategory(),
  //         HomeGardenCategory(),
  //       ],
  //     ),
  //   );
  // }
}

class ItemsData {
  String label;
  bool isSeleccted;
  ItemsData({required this.label, this.isSeleccted = false});
}
