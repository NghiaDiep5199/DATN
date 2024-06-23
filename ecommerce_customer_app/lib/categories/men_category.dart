import 'package:ecommerce_customer_app/utilities/categ_list.dart';
import 'package:ecommerce_customer_app/widgets/category_widget.dart';
import 'package:flutter/material.dart';

class MenCatagory extends StatelessWidget {
  const MenCatagory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CategoryHeaderLabel(
                    headerLabel: 'Men',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: GridView.count(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: List.generate(men.length - 1, (index) {
                        return SubCategoryModel(
                          mainCategoryName: 'Men',
                          subCategoryName: men[index + 1],
                          assetName: 'images/men/men$index.jpg',
                          subCategoryLabel: men[index + 1],
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
          //     mainCategoryName: 'Men',
          //   ),
          // ),
        ],
      ),
    );
  }
}
