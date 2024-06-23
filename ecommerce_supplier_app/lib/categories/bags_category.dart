import 'package:ecommerce_supplier_app/utilities/categ_list.dart';
import 'package:ecommerce_supplier_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class BagsCategory extends StatelessWidget {
  const BagsCategory({super.key});

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
                    headerLabel: 'Bags',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(bags.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Bags',
                          subCategoryName: bags[index + 1],
                          assetName: 'images/bags/bags$index.jpg',
                          subCategoryLabel: bags[index + 1],
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
