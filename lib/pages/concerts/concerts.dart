import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tickets/pages/creation/creation.dart';
import 'package:tickets/widgets/custom_app_bar.dart';

import '../../mixins/utils.dart';
import '../../models/marker.dart';
import '../../models/price.dart';
import '../../utils/constants/colors.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/lite_loading_screen.dart';
import 'controller.dart';

import 'widgets/price_card.dart';

class ConcertsScreen extends StatefulWidget {
  const ConcertsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConcertsScreenState createState() => ConcertsScreenState();
}

class ConcertsScreenState extends State<ConcertsScreen> with TickerProviderStateMixin {
  CarouselController carouselController = CarouselController();
  AnimationController? animationController;
  int currSeconds = 0;
  bool edition = false;

  @override
  void initState() {
    edition = false;
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<ConcertsScreenController>(
      init: ConcertsScreenController(),
      builder: (controller) {
        return controller.isLoading
            ? const LiteLoadingScreen()
            : CustomScaffold(
                appBar: CustomAppBar(
                  titleString: 'Концерты',
                  isShowBack: false,
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Мои концерты:',
                          style: Get.textTheme.bodyText1,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Card(
                              color: AppColors.WHITE,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                height: 64,
                                child: Text(
                                  'Подгорица 23.06.2023',
                                  style: Get.textTheme.bodyText2,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Card(
                                elevation: 5,
                                child: SizedBox(
                                  height: 64,
                                  width: 64,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Новый концерт:',
                          style: Get.textTheme.bodyText1,
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Название:  ',
                                      style: Get.textTheme.bodyText2,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.grey[200],
                                      width: 200,
                                      height: 36,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        style: Get.textTheme.bodyText2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Дата:  ',
                                      style: Get.textTheme.bodyText2,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.grey[200],
                                      width: 200,
                                      height: 36,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        style: Get.textTheme.bodyText2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Место:  ',
                                      style: Get.textTheme.bodyText2,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.grey[200],
                                      width: 200,
                                      height: 36,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        style: Get.textTheme.bodyText2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Сетка:  ',
                                      style: Get.textTheme.bodyText2,
                                    ),
                                    Text(
                                      'X:  ',
                                      style: Get.textTheme.bodyText1!.copyWith(color: AppColors.LIGHT_GREEN),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.grey[200],
                                      width: 82,
                                      height: 36,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        style: Get.textTheme.bodyText2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '  Y:  ',
                                      style: Get.textTheme.bodyText1!.copyWith(color: AppColors.LIGHT_GREEN),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.grey[200],
                                      width: 82,
                                      height: 36,
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        maxLines: 1,
                                        style: Get.textTheme.bodyText2,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                FloatingActionButton.extended(
                                  backgroundColor: AppColors.LIGHT_GREEN,
                                  onPressed: () {
                                    Get.to(
                                      CreationScreen(),
                                    );
                                  },
                                  label: Text(
                                    'Создать',
                                    style: Get.textTheme.bodyText1!.copyWith(color: AppColors.WHITE),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class PlaceWidgetController extends GetxController with Utils {}
