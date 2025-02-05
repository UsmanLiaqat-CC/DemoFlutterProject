import 'package:flutter/material.dart';

import '../utils/AppColor.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  // final Function(String)? onChanged;
  final bool? isPassword;
  final String? errorText;
  final Image? iconImage;
  final TextEditingController? controller;
  // final FormFieldValidator<String>? validator;
  final Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool? readonly;

  final VoidCallback? onTogglePasswordStatus;
  final int? maxLine;
  final int? minLine;
  final bool borderEnabled;
  final IconButton? mIconButton;
  final TextInputType? mInputType;


  const CustomTextField({
    super.key,
    required this.hintText,
    // this.onChanged,
    this.textInputAction,
    this.readonly,
    this.mInputType,

    this.isPassword,
    this.controller,
    this.errorText,
    this.iconImage,
    this.validator,
    this.onTogglePasswordStatus,
    this.maxLine,
    this.minLine,
    this.mIconButton,
    this.borderEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textInputAction: textInputAction,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: controller,
          readOnly: readonly??false,
          keyboardType: mInputType,
          minLines: minLine ?? 1,
          maxLines: maxLine ?? 1,
          decoration:  InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(
              color: AppColor.placeholder_text_color,
            ),
            filled: true,
            fillColor: Colors.white,

            border:  borderEnabled
                ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.grey),
            )
                : OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: mIconButton,
          ),

          // onChanged: onChanged,
          obscureText: isPassword ?? false,
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              return null;
            },
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
