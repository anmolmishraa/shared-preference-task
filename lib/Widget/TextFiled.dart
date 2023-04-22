import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final Color? baseColor;
  final Color? borderColor;
  final Color? errorColor;
  final TextInputType? inputType;
  final bool? obscureText;
  final Function? validator;
  final Function? onChanged;

  CustomTextField(
      {this.hint,
      this.errorText,
      this.controller,
      this.onChanged,
      this.baseColor,
      this.borderColor,
      this.errorColor,
      this.inputType = TextInputType.text,
      this.obscureText = false,
      this.validator});

  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Color? currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: currentColor ?? Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,

          obscureText: widget.obscureText ?? false,
          onChanged: (text) {
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
            setState(() {
              if (!widget.validator!(text) || text.length == 0) {
                currentColor = widget.errorColor;
              } else {
                currentColor = widget.baseColor;
              }
            });
          },
          //keyboardType: widget.inputType,
          autocorrect: true,
          controller: widget.controller,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: widget.baseColor,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w300,
            ),
            errorText: widget.errorText,
            border: InputBorder.none,
            hintText: widget.hint,
          ),
        ),
      ),
    );
  }
}
