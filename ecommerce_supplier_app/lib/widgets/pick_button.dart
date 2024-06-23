import 'package:flutter/material.dart';

class PickButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const PickButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sedan',
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
