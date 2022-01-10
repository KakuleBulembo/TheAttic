import 'package:flutter/material.dart';

class TextFormFieldContainer extends StatelessWidget {
  const TextFormFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      margin:const EdgeInsets.symmetric(vertical: 10),
      padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(29),
          border: Border.all(
            color: Colors.green.withOpacity(0.5),
          )
      ),
      child: child,
    );
  }
}