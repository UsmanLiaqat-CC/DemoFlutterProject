import 'package:flutter/material.dart';

import '../utils/AppColor.dart';
import '../utils/AppFonts.dart';

class SmallText extends StatelessWidget {
  final String text;

  const SmallText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: StyleRefer.poppinsBold.copyWith(fontSize: 12,fontWeight: FontWeight.bold,color: AppColor.textColor),
    );
  }
}