import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/finance/wallet_management.view.dart';
import 'package:fuodz/widgets/list_items/wallet_transaction.list_item.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  //
  WalletViewModel vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && vm != null) {
      vm.initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    if (vm == null) {
      vm = WalletViewModel(context);
    }

    //
    return BasePage(
      title: "Wallet".tr(),
      showLeadingAction: true,
      showAppBar: true,
      body: ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => vm,
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              //
              VStack(
                [
                  //
                  "Total Balance".tr().text.lg.make(),
                  vm.isBusy
                      ? BusyIndicator().py12()
                      : "${AppStrings.currencySymbol} ${vm.wallet.balance ?? 0.00}"
                          .currencyFormat()
                          .text
                          .xl3
                          .semiBold
                          .make()
                          .py4(),
                  HStack(
                    [
                      "Updated last at:".tr().text.xs.make(),
                      " ${vm.wallet != null ? DateFormat.yMMMMEEEEd(I18n.localeStr ?? "en").format(vm.wallet.updatedAt) : ''}"
                          .text
                          .sm
                          .make()
                          .expand(),
                    ],
                  ),
                ],
              )
                  .p12()
                  .box
                  .roundedSM
                  .outerShadow
                  .color(context.cardColor)
                  .make()
                  .wFull(context),

              //top-up
              CustomButton(
                loading: vm.isBusy,
                title: "Top-Up Wallet".tr(),
                onPressed: vm.showAmountEntry,
              ).py12().wFull(context),
              //
              WalletManagementView(
                viewmodel: vm,
                showBalance: false,
              ),

              //transactions list
              "Wallet Transactions".tr().text.bold.xl.make().py12(),
              CustomListView(
                refreshController: vm.refreshController,
                canPullUp: true,
                canRefresh: true,
                isLoading: vm.busy(vm.walletTransactions),
                onRefresh: vm.getWalletTransactions,
                onLoading: () =>
                    vm.getWalletTransactions(initialLoading: false),
                dataSet: vm.walletTransactions,
                itemBuilder: (context, index) {
                  return WalletTransactionListItem(
                      vm.walletTransactions[index]);
                },
              ).expand(),
            ],
          ).p20();
        },
      ),
    );
  }
}
