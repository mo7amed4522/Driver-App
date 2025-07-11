import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ridy/client/components/ride_option_item.dart';
import 'package:ridy/client/components/sheet_title_view.dart';

import 'generated/l10n.dart';

class RideOptionsSheetView extends StatelessWidget {
  const RideOptionsSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetTitleView(
              title: S.of(context).rider_options_dialog_title,
              closeAction: () => Navigator.pop(context),
            ),
            RideOptionItem(
                icon: Ionicons.close,
                text: S.of(context).action_cancel_ride,
                onPressed: () =>
                    Navigator.pop(context, RideOptionsResult.cancel)),
          ],
        ));
  }
}

enum RideOptionsResult { none, cancel }
