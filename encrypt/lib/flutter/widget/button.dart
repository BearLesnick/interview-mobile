import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final VoidCallback onTap;
  final bool isActive;

  const MainButton({Key key,
    @required this.text,
    @required this.onTap,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.borderColor = Colors.blue, this.isActive = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(
        ignoring:!isActive ,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: borderColor
                ),
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ),
        ),
      );
}
