import 'package:flutter/material.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({
    Key key,
    this.onSubmitted,
    this.search,
  }) : super(key: key);

  //
  final Search search;
  final Function(Search) onSubmitted;

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //filter by location or not
        HStack(
          [
            Checkbox(
              value: widget.search.byLocation,
              onChanged: (value) {
                setState(() {
                  widget.search.byLocation = value;
                });
              },
            ),
            UiSpacer.smHorizontalSpace(),
            "Filter by location".tr().text.make().expand(),
          ],
        ).onInkTap(() {
          setState(() {
            widget.search.byLocation = !widget.search.byLocation;
          });
        }),
        //tags

        //
        CustomButton(
          title: "Submit".tr(),
          onPressed: () {
            widget.onSubmitted(widget.search);
            context.pop();
          },
        ).centered().py16(),
      ],
    )
        .p20()
        .scrollVertical()
        .box
        .topRounded()
        .color(context.backgroundColor)
        .make();
        // .h(context.percentHeight * 90);
  }
}
