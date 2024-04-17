import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/home/controllers/home_controller.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../product/domain/models/basic_campaign_model.dart';

class WebBannerViewWidget extends StatelessWidget {
  final HomeController homeController;

  const WebBannerViewWidget({Key? key, required this.homeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      // padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      alignment: Alignment.center,
      child: Column(
        children: [
          homeController.bannerImageList != null
              ? SizedBox(
            // width: 1210,
            height: 225,
            child: CarouselSlider.builder(
              itemCount: homeController.bannerImageList!.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return InkWell(
                  onTap: () => _onTap(index, context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImageWidget(
                      image: '${_getImageBaseUrl(index)}/${homeController.bannerImageList![index]}',
                      fit: BoxFit.cover,
                      width: 1210,
                      // height: 220,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 1210 / 225,
                autoPlay: true,
                enlargeCenterPage: true,
                padEnds: true,
                autoPlayInterval: const Duration(seconds: 3),
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  homeController.setCurrentIndex(index, true);
                },
              ),
            ),
          )
              : WebBannerShimmer(bannerController: homeController),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          homeController.bannerImageList != null
              ? Builder(builder: (context) {
            int totalBanner = homeController.bannerImageList!.length;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalBanner, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: index == homeController.currentIndex
                      ? Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: Text(
                      '${index + 1}/$totalBanner',
                      style: robotoRegular.copyWith(color: Colors.white, fontSize: 12),
                    ),
                  )
                      : Container(
                    height: 4.18,
                    width: 5.57,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                  ),
                );
              }),
            );
          })
              : const SizedBox(),
        ],
      ),
    );
  }

  String? _getImageBaseUrl(int index) {
    if (homeController.bannerDataList![index] is BasicCampaignModel) {
      return Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl;
    } else {
      return Get.find<SplashController>().configModel!.baseUrls!.bannerImageUrl;
    }
  }

  void _onTap(int index, BuildContext context) {
    if (homeController.bannerDataList![index] is Product) {
      Product? product = homeController.bannerDataList![index];
      ResponsiveHelper.isMobile(context)
          ? showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (con) => ProductBottomSheetWidget(product: product),
      )
          : showDialog(
        context: context,
        builder: (con) => Dialog(child: ProductBottomSheetWidget(product: product)),
      );
    } else if (homeController.bannerDataList![index] is Restaurant) {
      Restaurant restaurant = homeController.bannerDataList![index];
      Get.toNamed(
        RouteHelper.getRestaurantRoute(restaurant.id),
        arguments: RestaurantScreen(restaurant: restaurant),
      );
    } else if (homeController.bannerDataList![index] is BasicCampaignModel) {
      BasicCampaignModel campaign = homeController.bannerDataList![index];
      Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
    }
  }
}

class WebBannerShimmer extends StatelessWidget {
  final HomeController bannerController;

  const WebBannerShimmer({Key? key, required this.bannerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: bannerController.bannerImageList == null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
