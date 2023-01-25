import 'package:flutter/material.dart';


class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextStyle? style;
  final TextAlign? align;
  final String? fontFamily;
  final TextOverflow? overflow;
  final bool isTitle;
  final int? maxLines;

  const AppText(this.text,
      {this.align,
      this.color,
      this.size,
      this.weight,
      this.overflow,
      this.style,
      this.fontFamily,
      this.isTitle = false,
      this.maxLines,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        maxLines: maxLines,
        overflow: overflow,
        style: style ??
            TextStyle(
                fontFamily: fontFamily,
                color: color ?? Colors.black,
                fontWeight:
                    weight ?? (!isTitle ? FontWeight.w400 : FontWeight.w500),
                fontSize: size ?? (!isTitle ? 13.0 : 24.0)));
  }
}
