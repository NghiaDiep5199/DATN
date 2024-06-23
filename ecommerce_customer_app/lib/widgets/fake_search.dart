import 'package:ecommerce_customer_app/minor_screens/search.dart';
import 'package:flutter/material.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Image.asset(
            'images/logostore.png',
            fit: BoxFit.cover,
            width: 90,
            height: 45,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          },
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.67,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.4),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'What are you looking for?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: 'Sedan',
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
                // Container(
                //   height: 32,
                //   decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.circular(25)),
                //   child: const Center(
                //     child: Text(
                //       'Search',
                //       style: TextStyle(
                //           fontSize: 16,
                //           color: Colors.black,
                //           fontFamily: 'Sedan',
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
