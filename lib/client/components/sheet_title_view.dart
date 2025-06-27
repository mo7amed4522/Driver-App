import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ridy/client/theme/theme.dart';

class SheetTitleView extends StatelessWidget {
  final String title;
  final Function()? closeAction;
  const SheetTitleView({required this.title, this.closeAction, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            if (closeAction != null)
              CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: closeAction,
                  minimumSize: Size(0, 0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: CustomTheme.neutralColors.shade800,
                            width: 1.5)),
                    child: Icon(
                      Icons.close,
                      color: CustomTheme.neutralColors.shade800,
                      size: 18,
                    ),
                  )),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 4),
          child: Divider(
            color: CustomTheme.primaryColors.shade300,
          ),
        )
      ],
    );
  }
}
