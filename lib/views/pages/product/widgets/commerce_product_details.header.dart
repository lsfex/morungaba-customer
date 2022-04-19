import 'package:flutter/material.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductDetailsHeader extends StatelessWidget {
  const CommerceProductDetailsHeader(
      {this.product, this.showVendor = true, Key key})
      : super(key: key);

  final Product product;
  final bool showVendor;

  @override
  Widget build(BuildContext context) {
    //
    final currencySymbol = AppStrings.currencySymbol;

    return VStack(
      [
        
        //product name
        product.name.text.sm.semiBold.make(),

        //price
        HStack(
          [
            //price
            CurrencyHStack(
              [
                currencySymbol.text.lg.bold.color(context.primaryColor).make(),
                product.sellPrice.currencyValueFormat()
                    .text
                    .xl2
                    .bold.color(context.primaryColor)
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.end,
            ),
            UiSpacer.smHorizontalSpace(),
            //discount
            CustomVisibilty(
              visible: product.showDiscount,
              child: CurrencyHStack(
                [
                  currencySymbol.text.lineThrough.xs.color(context.primaryColor).make(),
                  product.price
                      .currencyValueFormat()
                      .text
                      .lineThrough
                      .lg
                      .thin.color(context.primaryColor)
                      .make(),
                ],
              ),
            ),
          ],
        ),

        //product size details and more
        HStack(
          [
            //deliverable or not
            (product.canBeDelivered
                    ? "Deliverable".tr()
                    : "Not Deliverable".tr())
                .text
                .white
                .sm
                .make()
                .py4()
                .px8()
                .box
                .roundedLg
                .color(
                  product.canBeDelivered ? Vx.green500 : Vx.red500,
                )
                .make(),

            //
            UiSpacer.expandedSpace(),

            //size
            CustomVisibilty(
              visible: !product.capacity.isEmptyOrNull &&
                  !product.unit.isEmptyOrNull,
              child: "${product.capacity} ${product.unit}"
                  .text
                  .sm
                  .black
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .gray500
                  .make()
                  .pOnly(right: Vx.dp12),
            ),

            //package items
            CustomVisibilty(
              visible: product.packageCount != null,
              child: "%s Items"
                  .tr()
                  .fill(["${product.packageCount}"])
                  .text
                  .sm
                  .black
                  .make()
                  .py4()
                  .px8()
                  .box
                  .roundedLg
                  .gray500
                  .make(),
            ),
          ],
        ).pOnly(top: Vx.dp10),
      ],
    ).px20().py12();
  }
}
