import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF2A2D3E);
const kBackgroundColor = Color(0xFF212332);

const kBottomRounded = RoundedRectangleBorder(
  side: BorderSide(color: kPrimaryColor, width: 1),
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(30),
    bottomRight: Radius.circular(30),
  ),
);
const kRoundedBorder = RoundedRectangleBorder(
  side: BorderSide(color: kPrimaryColor, width: 1),
  borderRadius: BorderRadius.all(
    Radius.circular(0),
  ),
);