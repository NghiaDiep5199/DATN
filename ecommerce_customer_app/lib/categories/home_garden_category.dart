import 'package:ecommerce_customer_app/utilities/categ_list.dart';
import 'package:ecommerce_customer_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class HomeGardenCategory extends StatelessWidget {
  const HomeGardenCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CategoryHeaderLabel(
                    headerLabel: 'Home & Garden',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children:
                          List.generate(homeandgarden.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Home & Garden',
                          subCategoryName: homeandgarden[index + 1],
                          assetName: 'images/homegarden/home$index.jpg',
                          subCategoryLabel: homeandgarden[index + 1],
                        );
                      }),
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
}
