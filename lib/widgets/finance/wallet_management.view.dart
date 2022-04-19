import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletManagementView extends StatefulWidget {
  const WalletManagementView({this.viewmodel, this.showBalance = true, Key key})
      : super(key: key);

  final bool showBalance;
  final WalletViewModel viewmodel;

  @override
  State<WalletManagementView> createState() => _WalletManagementViewState();
}

class _WalletManagementViewState extends State<WalletManagementView>
    with WidgetsBindingObserver {
  WalletViewModel mViewmodel;
  @override
  void initState() {
    super.initState();
    setState(() {
      mViewmodel = widget.viewmodel;
    });

    //
    if (mViewmodel == null) {
      mViewmodel = WalletViewModel(context);
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mViewmodel != null) {
      mViewmodel.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletViewModel>.reactive(
      viewModelBuilder: () => mViewmodel,
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return StreamBuilder(
          stream: AuthServices.listenToAuthState(),
          builder: (ctx, snapshot) {
            //
            if (!snapshot.hasData) {
              return UiSpacer.emptySpace();
            }
            //view
            return VStack(
              [
                //
                CustomVisibilty(
                  visible: widget.showBalance,
                  child: UiSpacer.verticalSpace(),
                ),
                //
                CustomVisibilty(
                  visible: widget.showBalance,
                  child: HStack(
                    [
                      //
                      VStack(
                        [
                          //
                          // "${AppStrings.currencySymbol} ${vm.wallet.balance ?? 0.00}"
                          "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet.balance : 0.00}"
                              .currencyFormat()
                              .text
                              .xl3
                              .semiBold
                              .make(),
                          "Wallet Balance".tr().text.make(),
                        ],
                      ).expand(),
                      UiSpacer.horizontalSpace(space: 5),
                      //buttons
                      Visibility(
                        visible: !vm.isBusy,
                        child: HStack(
                          [
                            //topup button
                            CustomButton(
                              onPressed: vm.showAmountEntry,
                              child: FittedBox(
                                child: VStack(
                                  [
                                    Icon(
                                      // Icons.add,
                                      FlutterIcons.plus_ant,
                                    ),
                                    UiSpacer.verticalSpace(space: 2),
                                    //
                                    "Top-Up".tr().text.make(),
                                  ],
                                  crossAlignment: CrossAxisAlignment.center,
                                ).py8(),
                              ),
                            ),
                            UiSpacer.horizontalSpace(space: 5),
                            //tranfer button
                            CustomButton(
                              onPressed: vm.showWalletTransferEntry,
                              child: FittedBox(
                                child: VStack(
                                  [
                                    Icon(
                                      Icons.account_balance_wallet_rounded,
                                    ),
                                    UiSpacer.verticalSpace(space: 2),
                                    //
                                    "SEND".tr().text.make(),
                                  ],
                                  crossAlignment: CrossAxisAlignment.center,
                                ).py8(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //
                      Visibility(
                        visible: vm.isBusy,
                        child: BusyIndicator(),
                      ),
                    ],
                  ).p12().card.make().px20(),
                ),

                //no balance just transfer
                CustomVisibilty(
                  visible: !widget.showBalance,
                  child: CustomButton(
                    onPressed: vm.showWalletTransferEntry,
                    child: FittedBox(
                      child: HStack(
                        [
                          Icon(
                            Icons.account_balance_wallet_rounded,
                          ),
                          UiSpacer.smHorizontalSpace(),
                          //
                          "SEND".tr().text.make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ).py8(),
                    ),
                  ).wFull(context),
                ),
                //
                CustomVisibilty(
                  visible: !widget.showBalance,
                  child: UiSpacer.verticalSpace(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
