import 'package:attic/components/text_field_container.dart';
import 'package:flutter/material.dart';


class RoundedInputField extends StatelessWidget {
  const RoundedInputField({
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.validator,
    Key? key,
  }) : super(key: key);
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final dynamic validator;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldContainer(
      child: TextFormField(
        cursorColor: Colors.green,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: Colors.green,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}