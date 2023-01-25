import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class InputBox extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final TextInputType? inputType;
  final bool obscureText;
  final bool isEnabled;
  final void Function(String?)? onChanged;
  final bool isPasswordInput;
  final int? maxLines;
  final String? Function(String?)? validator;
  InputBox(
      {required this.controller,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.inputType,
      this.obscureText = false,
      this.isEnabled = true,
      this.onChanged,
      this.isPasswordInput = false,
      this.maxLines = 1,
      this.validator,
      super.key});

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  late bool _isTextObsured;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isTextObsured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        enabled: widget.isEnabled,
        maxLines: widget.maxLines,
        validator: widget.validator ?? ValidationBuilder().required().build(),
        controller: widget.controller,
        keyboardType: widget.inputType,
        obscureText: _isTextObsured,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            hintStyle: TextStyle(height: widget.maxLines! > 1 ? 2 : 1),
            alignLabelWithHint: true,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPasswordInput
                ? _isTextObsured
                    ? InkWell(
                        onTap: () => setState(() {
                              _isTextObsured = !_isTextObsured;
                            }),
                        child: const Icon(Icons.visibility))
                    : InkWell(
                        onTap: () => setState(() {
                              _isTextObsured = !_isTextObsured;
                            }),
                        child: const Icon(Icons.visibility_off))
                : null,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE4DFDF))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            hintText: widget.hintText ?? "",
            labelText: widget.labelText ?? "",
            labelStyle: const TextStyle(fontSize: 14.0),
            floatingLabelBehavior: FloatingLabelBehavior.never),
      ),
    );
  }
}
