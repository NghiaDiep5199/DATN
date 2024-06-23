import 'package:ecommerce_supplier_app/minor_screens/subcategory_products.dart';
import 'package:flutter/material.dart';

class SliderBar extends StatelessWidget {
  final String mainCategoryName;

  const SliderBar({super.key, required this.mainCategoryName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.82,
      width: MediaQuery.of(context).size.width * 0.055,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainCategoryName == 'beauty'
                    ? const Text('')
                    : const Text(' << ', style: style),
                Text(mainCategoryName.toUpperCase(), style: style),
                mainCategoryName == 'men'
                    ? const Text('')
                    : const Text(' >> ', style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const style = TextStyle(
  color: Colors.blue,
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 10,
  fontFamily: 'Sedan',
);

class SubCategoryModel extends StatelessWidget {
  final String mainCategoryName;
  final String subCategoryName;
  final String assetName;
  final String subCategoryLabel;
  const SubCategoryModel({
    super.key,
    required this.mainCategoryName,
    required this.subCategoryName,
    required this.assetName,
    required this.subCategoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoryProducts(
                      maincategName: mainCategoryName,
                      subcategName: subCategoryName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: Image(
              image: AssetImage(assetName),
            ),
          ),
          Text(
            subCategoryLabel,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Sedan',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategoryHeaderLabel({super.key, required this.headerLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Sedan',
          letterSpacing: 2,
        ),
      ),
    );
  }
}
