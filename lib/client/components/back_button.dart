import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ridy/client/theme/theme.dart';

class RidyBackButton extends StatelessWidget {
  final String text;

  const RidyBackButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => Navigator.pop(context),
      padding: const EdgeInsets.all(0),
      minimumSize: Size(0, 0),
      child: Stack(
        children: [
          Positioned(
            left: -7,
            child: Icon(
              Ionicons.chevron_back,
              color: CustomTheme.neutralColors.shade800,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              text,
              style: TextStyle(color: CustomTheme.neutralColors.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
