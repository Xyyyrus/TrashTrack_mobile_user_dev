// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   const CustomTextField({
//     super.key,
//     this.textController,
//     this.prefixIcon,
//     this.labelText,
//     this.onPressed,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.validator,
//     this.maxLines = 1,
//   });

//   final TextEditingController? textController;
//   final IconData? prefixIcon;
//   final String? labelText;
//   final void Function()? onPressed;
//   final IconData? suffixIcon;
//   final bool obscureText;
//   final FormFieldValidator<String>? validator;
//   final int maxLines;

//   OutlineInputBorder borderStyle(Color borderColor) {
//     return OutlineInputBorder(
//       borderSide: BorderSide(color: borderColor, width: 1),
//       borderRadius: const BorderRadius.all(Radius.circular(12)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: textController,
//       decoration: InputDecoration(
//         prefixIcon: Icon(prefixIcon ?? Icons.keyboard),
//         labelText: labelText,
//         suffixIcon: IconButton(
//           onPressed: onPressed,
//           icon: Icon(suffixIcon),
//         ),
//         focusedBorder: borderStyle(Colors.green),
//         enabledBorder: borderStyle(Colors.grey),
//       ),
//       obscureText: obscureText,
//       validator: validator,
//       maxLines: maxLines,
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.textController,
    this.prefixIcon,
    this.labelText,
    this.onPressed,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.onChanged, // Added onChanged to the constructor
  });

  final TextEditingController? textController;
  final IconData? prefixIcon;
  final String? labelText;
  final void Function()? onPressed;
  final IconData? suffixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final ValueChanged<String>? onChanged; // Correct type for onChanged

  OutlineInputBorder borderStyle(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon ?? Icons.keyboard),
        labelText: labelText,
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(suffixIcon),
        ),
        focusedBorder: borderStyle(Colors.green),
        enabledBorder: borderStyle(Colors.grey),
      ),
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChanged, // Ensure this is set here
    );
  }
}
