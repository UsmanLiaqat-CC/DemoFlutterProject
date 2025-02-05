import 'package:flutter/material.dart';

import '../utils/AppFonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppBar({super.key, required this.title, this.leading, this.actions,});

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: Text(
        title,
        style: StyleRefer.poppinsSemiBold.copyWith(fontWeight: FontWeight.bold,fontSize: 20)
      ),
      centerTitle: true,
      leading: leading ?? Container(),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
