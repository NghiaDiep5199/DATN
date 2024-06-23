import 'package:ecommerce_supplier_app/utilities/categ_list.dart';
import 'package:ecommerce_supplier_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class ElectronicsCategory extends StatelessWidget {
  const ElectronicsCategory({super.key});

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
                    headerLabel: 'Electronics',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(electronics.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Electronics',
                          subCategoryName: electronics[index + 1],
                          assetName: 'images/electronics/electronics$index.jpg',
                          subCategoryLabel: electronics[index + 1],
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
