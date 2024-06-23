import 'package:ecommerce_customer_app/utilities/categ_list.dart';
import 'package:ecommerce_customer_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class KidsCategory extends StatelessWidget {
  const KidsCategory({super.key});

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
                    headerLabel: 'Kids',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(kids.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Kids',
                          subCategoryName: kids[index + 1],
                          assetName: 'images/kids/kids$index.jpg',
                          subCategoryLabel: kids[index + 1],
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
