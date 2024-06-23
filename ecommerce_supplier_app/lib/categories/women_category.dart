import 'package:ecommerce_supplier_app/utilities/categ_list.dart';
import 'package:ecommerce_supplier_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class WomenCategory extends StatelessWidget {
  const WomenCategory({super.key});

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
                    headerLabel: 'Women',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(women.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Women',
                          subCategoryName: women[index + 1],
                          assetName: 'images/women/women$index.jpg',
                          subCategoryLabel: women[index + 1],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: SliderBar(
          //     mainCategoryName: 'Women',
          //   ),
          // ),
        ],
      ),
    );
  }
}
