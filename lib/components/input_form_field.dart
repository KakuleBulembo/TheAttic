import 'package:flutter/material.dart';

import '../constants.dart';


class InputFormField extends StatelessWidget {
  const InputFormField({
    Key? key,
    this.initialValue = '',
    required this.label,
    required this.hintText,
    required this.maxLines,
    required this.minLines,
    required this.onChanged,
    required this.shape,
    required this.validator,
  }) : super(key: key);

  final String initialValue;
  final String label;
  final String hintText;
  final int maxLines;
  final int minLines;
  final ValueChanged<String> onChanged;
  final ShapeBorder shape;
  final dynamic validator;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * 0.9,
        child: Card(
          color: kPrimaryColor,
          shadowColor: kPrimaryColor,
          elevation: 0.5,
          shape: shape,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0
                    ),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.green,
                height: 2,
              ),
              TextFormField(
                validator: validator,
                initialValue: initialValue,
                textAlign: TextAlign.center,
                cursorColor: Colors.green,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.green.withOpacity(0.5),
                  ),
                  focusedBorder:const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                maxLines: maxLines,
                minLines: minLines,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}