import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/view_models/taxi.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderTaxiButton extends StatelessWidget {
  const OrderTaxiButton(this.vm, {Key key}) : super(key: key);

  final TaxiViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Visibility(
        visible: vm.selectedVehicleType != null,
        child: CustomButton(
          loading: vm.isBusy,
          child: HStack(
            [
              "Order Now".tr().text.make(),
              " ".text.make(),
              "${(vm.selectedVehicleType != null && vm.selectedVehicleType.currency != null ? vm.selectedVehicleType.currency.symbol : AppStrings.currencySymbol)} ${vm.total}"
                  .currencyFormat()
                  .text
                  .semiBold
                  .xl
                  .make(),
            ],
          ),
          onPressed: vm.selectedVehicleType != null ? vm.processNewOrder : null,
        )
            .p20()
            .wFull(context)
            .box
            .color(context.backgroundColor)
            .shadow2xl
            .make(),
      ),
    );
  }
}
