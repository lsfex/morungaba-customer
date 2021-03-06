import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_parcel.vm.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class ParcelDeliveryDiscountSection extends StatelessWidget {
  const ParcelDeliveryDiscountSection(this.vm, {Key key}) : super(key: key);

  final NewParcelViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        "Add Coupon".tr().text.semiBold.xl.make(),
        UiSpacer.verticalSpace(space: 10),
        //
        HStack(
          [
            //
            CustomTextFormField(
              hintText: "Coupon Code".tr(),
              textEditingController: vm.couponTEC,
              errorText: vm.hasErrorForKey(vm.coupon)
                  ? vm.error(vm.coupon).toString()
                  : null,
              onChanged: vm.couponCodeChange,
            ).expand(flex: 2),
            //
            UiSpacer.horizontalSpace(),
            Column(
              children: [
                CustomButton(
                  title: "Apply".tr(),
                  isFixedHeight: true,
                  loading: vm.busy(vm.coupon),
                  onPressed: vm.canApplyCoupon ? vm.applyCoupon : null,
                ).h(Vx.dp56),
                //
                vm.hasErrorForKey(vm.coupon)
                    ? UiSpacer.verticalSpace(space: 12)
                    : UiSpacer.verticalSpace(space: 1),
              ],
            ).expand(),
          ],
        ),
      ],
    );
  }
}
