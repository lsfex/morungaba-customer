import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/option_group.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/product_details.vm.dart';
import 'package:fuodz/views/pages/commerce/widgets/similar_commerce_products.view.dart';
import 'package:fuodz/views/pages/product/widgets/commerce_product_details.header.dart';
import 'package:fuodz/views/pages/product/widgets/product_details_cart.bottom_sheet.dart';
import 'package:fuodz/views/pages/product/widgets/product_image.gallery.dart';
import 'package:fuodz/views/pages/product/widgets/product_option_group.dart';
import 'package:fuodz/views/pages/product/widgets/product_options.header.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CommerceProductDetailsPage extends StatelessWidget {
  CommerceProductDetailsPage({this.product, Key key}) : super(key: key);

  final Product product;

  //
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(context, product),
      onModelReady: (model) => model.getProductDetails(),
      builder: (context, model, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          elevation: 0,
          appBarColor: Colors.transparent,
          appBarItemColor: AppColor.primaryColor,
          showCart: true,
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              //product image
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Hero(
                    tag: model.product.heroTag,
                    child: ProductImagesGalleryView(model.product),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: VStack(
                  [
                    //product header
                    CommerceProductDetailsHeader(
                      product: model.product,
                      showVendor: false,
                    ),
                    UiSpacer.divider().pOnly(bottom: Vx.dp12),

                    //product details
                    model.product.description.text.light.sm.make().px20(),

                    //options header
                    Visibility(
                      visible: model.product.optionGroups.isNotEmpty,
                      child: VStack(
                        [
                          ProductOptionsHeader(
                            description:
                                "Select options to add them to the product"
                                    .tr(),
                          ),

                          //options
                          model.busy(model.product)
                              ? BusyIndicator().centered().py20()
                              : VStack(
                                  [
                                    ...buildProductOptions(model),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    //similar products
                    SimilarCommerceProducts(product),
                  ],
                )
                    .pOnly(bottom: context.percentHeight * 30)
                    .box
                    .outerShadow
                    .color(context.backgroundColor)
                    .topRounded(value: 20)
                    .clip(Clip.antiAlias)
                    .make(),
              ),
            ],
          ).box.color(AppColor.faintBgColor).make(),
          bottomSheet: ProductDetailsCartBottomSheet(model: model),
        );
      },
    );
  }

  //
  buildProductOptions(model) {
    return model.product.optionGroups.map((OptionGroup optionGroup) {
      return ProductOptionGroup(optionGroup: optionGroup, model: model)
          .pOnly(bottom: Vx.dp12);
    }).toList();
  }
}
