import 'package:ecommerce_customer_app/utilities/categ_list.dart';
import 'package:ecommerce_customer_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class BeautyCategory extends StatelessWidget {
  const BeautyCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CategoryHeaderLabel(
                    headerLabel: 'Beauty',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(beauty.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Beauty',
                          subCategoryName: beauty[index + 1],
                          assetName: 'images/beauty/beauty$index.jpg',
                          subCategoryLabel: beauty[index + 1],
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
