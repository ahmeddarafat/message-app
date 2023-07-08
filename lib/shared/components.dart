import 'package:flutter/material.dart';

// TextFormField defaultTextField({
//   String? label,
//   IconData? icon,
//   String? hint,
//   void Function(String value)? onChanged,
//   bool hidePassword = false,
//   required String? Function(String? value) validator,
//   required TextEditingController? controller,
// }) {
//   return TextFormField(
//     controller: controller,
//     validator: validator,
//     obscureText: hidePassword,
//     onChanged: onChanged,
//     decoration: InputDecoration(
//       labelText: label,
//       hintText: hint,
//       prefixIcon: Icon(icon),
//       border: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(25)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.yellow[700]!,
//         ),
//         borderRadius: const BorderRadius.all(Radius.circular(25)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.blue[700]!,
//         ),
//         borderRadius: const BorderRadius.all(Radius.circular(25)),
//       ),
//     ),
//   );
// }

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
     MyTextField({
    Key? key,
    this.label,
    this.icon,
    this.hint,
    this.hidePassword = false,
    this.onChanged,
    required this.validator,
    required this.controller,
  }) : super(key: key) ;

  final String? label;
  final IconData? icon;
  final String? hint;
  final void Function(String value)? onChanged;
  bool hidePassword ;
  final String? Function(String? value) validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: hidePassword,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.yellow[700]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue[700]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}

MaterialButton myButton({String? title, Color? color, VoidCallback? onPress}) =>
    MaterialButton(
      minWidth: double.infinity,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      color: color,
      child: Text(
        title!,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: onPress,
    );
