import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoogleTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextCapitalization? textCapitalization;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;

  const GoogleTextField({
    super.key,
    this.prefixIcon,this.inputFormatters,
    this.onChanged,
    required this.hintText,
    required this.controller,
    this.validator,
    this.textCapitalization,this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(20),
      child: TextFormField(
inputFormatters: inputFormatters,
onChanged: onChanged,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization??TextCapitalization.none,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              width: 0.6,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          isDense: true,
        ),
      ),
    );
  }
}
