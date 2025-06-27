import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ridy/client/theme/theme.dart';

class LightColoredButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onPressed;

  const LightColoredButton(
      {required this.icon,
      required this.text,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        minimumSize: Size(0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: CustomTheme.primaryColors.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ));
  }
}
