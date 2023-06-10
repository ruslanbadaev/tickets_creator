import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/marker.dart';
import '../../models/price.dart';
import '../../utils/constants/colors.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/lite_loading_screen.dart';
import 'controller.dart';
import 'widgets/creation_dialog.dart';
import 'widgets/price_card.dart';

class CreationScreen extends StatefulWidget {
  const CreationScreen({
    Key? key,
  }) : super(key: key);

  @override
  CreationScreenState createState() => CreationScreenState();
}

class CreationScreenState extends State<CreationScreen> with TickerProviderStateMixin {
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

    return GetBuilder<CreationScreenController>(
      init: CreationScreenController(),
      builder: (controller) {
        return controller.isLoading
            ? const LiteLoadingScreen()
            : GestureDetector(
                onLongPressStart: (_) {
                  log('llklklkl1');
                  setState(() {
                    edition = true;
                  });
                },
                onLongPressEnd: (_) {
                  setState(() {
                    edition = false;
                  });
                },
                child: CustomScaffold(
                  backgroundColor: AppColors.WHITE,
                  body: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Цены:',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                '  Cоздать метку:',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 36),
                                          InkWell(
                                            onTap: () {
                                              Get.defaultDialog(
                                                title: '  Создание метки  ',
                                                titleStyle: const TextStyle(fontSize: 36),
                                                content: const CreationDialogWidget(),
                                              );
                                            },
                                            child: const Card(
                                              color: Colors.greenAccent,
                                              child: SizedBox(
                                                height: 48,
                                                width: 48,
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  for (PriceModel price in controller.prices)
                                    PriceCardWidget(
                                      price: price,
                                      selectedPrice: controller.selectedPrice,
                                      selectPrice: (price) => controller.selectPrice(price),
                                      onDeletePrice: (price) => controller.removePrice(price),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                for (var j = 0; j < 20; j++)
                                  Row(
                                    children: [
                                      for (var i = 0; i < 20; i++)
                                        PlaceWidget(
                                          editing: edition && controller.selectedPrice != null,
                                          onHover: (marker) {
                                            log((marker?.row).toString());
                                          },
                                          marker: MarkerModel(
                                            id: controller.selectedPrice?.id ?? '??',
                                            name: controller.selectedPrice?.name ?? '?',
                                            color: controller.selectedPrice?.color ?? Colors.red,
                                            type: controller.selectedPrice?.type,
                                            row: i,
                                            column: j,
                                          ),
                                        ),
                                    ],
                                  ),
                                const SizedBox(height: 72),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

class PlaceWidget extends StatefulWidget {
  final bool editing;
  final MarkerModel? marker;
  final Function(MarkerModel?) onHover;
  const PlaceWidget({
    Key? key,
    required this.editing,
    required this.onHover,
    this.marker,
  }) : super(key: key);

  @override
  State<PlaceWidget> createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  MarkerModel? currentMarker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        onEnter: (event) {
          if (widget.editing) {
            setState(() {
              currentMarker = widget.marker;
            });
          } else {
            widget.onHover(currentMarker);
          }
        },
        onHover: (event) {},
        cursor: SystemMouseCursors.grab,
        child: widget.editing
            ? SizedBox(
                height: 25,
                width: 25,
                // margin: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentMarker == null)
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    else
                      Container(
                        alignment: Alignment.center,
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          color: currentMarker?.color ?? Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                  ],
                ),
              )
            : SizedBox(
                height: 25,
                width: 25,
                // margin: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentMarker == null)
                      Container(
                        alignment: Alignment.center,
                        height: 7,
                        width: 7,
                        decoration: BoxDecoration(
                          color: currentMarker?.color ?? Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      )
                    else
                      currentMarker?.type == PointType.sit
                          ? Container(
                              alignment: Alignment.center,
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: currentMarker?.color ?? Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: currentMarker?.color ?? Colors.grey,
                                // borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                  ],
                ),
              ),
      ),
    );
  }
}
