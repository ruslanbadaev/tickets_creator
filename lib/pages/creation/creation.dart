import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/utils.dart';
import '../../models/marker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/theme/app_text_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/lite_loading_screen.dart';
import 'controller.dart';
import 'widgets/creation_dialog.dart';
import 'widgets/price_card.dart';

class CreationScreen extends StatefulWidget {
  final String id;
  final String name;
  final String date;
  final String place;
  final int rows;
  final int columns;

  const CreationScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.date,
    required this.place,
    required this.rows,
    required this.columns,
  }) : super(key: key);

  @override
  CreationScreenState createState() => CreationScreenState();
}

class CreationScreenState extends State<CreationScreen> with TickerProviderStateMixin {
  CarouselController carouselController = CarouselController();
  AnimationController? animationController;
  int currSeconds = 0;
  bool edition = false;

  CreationScreenController controller = Get.put(CreationScreenController());

  @override
  void initState() {
    edition = false;
    super.initState();
    initGrid();
    controller.getAllMarkersByConcertId(widget.id);
    controller.getGridByConcertId(widget.id);
    animationController = AnimationController(vsync: this);
  }

  void initGrid() {
    controller.generateGrid(widget.rows, widget.columns);
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
                  appBar: CustomAppBar(titleString: '${widget.name} - ${widget.date} (${widget.place})'),
                  backgroundColor: AppColors.WHITE,
                  body: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 24),
                                Text(
                                  'Цены:',
                                  style: Get.textTheme.headline3Bold,
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 320,
                                        child: Card(
                                          elevation: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '  Создать метку:',
                                                      style: Get.textTheme.bodyText2,
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    Get.defaultDialog(
                                                      title: '  Создание метки  ',
                                                      titleStyle: Get.textTheme.bodyText1,
                                                      content: CreationDialogWidget(
                                                        concertId: widget.id,
                                                      ),
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
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectPrice(
                                            MarkerModel(
                                              id: '0',
                                              name: 'no name',
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                        child: const Card(
                                          elevation: 5,
                                          child: SizedBox(
                                            height: 72,
                                            width: 72,
                                            child: Icon(
                                              Icons.cleaning_services_rounded,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (MarkerModel price in controller.prices)
                                        PriceCardWidget(
                                          price: price,
                                          selectedPrice: controller.selectedPrice,
                                          selectPrice: (price) => controller.selectPrice(price),
                                          onDeletePrice: (price) {
                                            Get.defaultDialog(
                                              title: 'Вы уверены, что хотите удалить ценовую метку?',
                                              titleStyle: Get.textTheme.bodyText1,
                                              content: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      controller.removePrice(price);
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      'Да',
                                                      style: Get.textTheme.bodyText2!.copyWith(),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      'Нет',
                                                      style: Get.textTheme.bodyText2!.copyWith(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            'Концертный зал:',
                            style: Get.textTheme.headline3Bold,
                          ),
                          const SizedBox(height: 16),
                          // Card(
                          //   child: Container(
                          //     width: 220,
                          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          //     // color: AppColors.LIGHT_GREY,
                          //     child: Column(
                          //       children: [
                          //         // Row(
                          //         //   children: [
                          //         //     Text(controller.selectedPrice.toString(), style: Get.textTheme.bodyText1),
                          //         //   ],
                          //         // ),
                          //         Row(
                          //           children: [
                          //             Text('id:', style: Get.textTheme.bodyText1),
                          //             Text(controller.hoveredPrice?.id ?? '---', style: Get.textTheme.bodyText2),
                          //           ],
                          //         ),
                          //         Row(
                          //           children: [
                          //             Text('Имя:', style: Get.textTheme.bodyText1),
                          //             Text(controller.hoveredPrice?.name ?? '---', style: Get.textTheme.bodyText2),
                          //           ],
                          //         ),
                          //         Row(
                          //           children: [
                          //             Text('Цена:', style: Get.textTheme.bodyText1),
                          //             Text(controller.hoveredPrice?.price ?? '---', style: Get.textTheme.bodyText2),
                          //           ],
                          //         ),
                          //         Row(
                          //           children: [
                          //             Text('Место:x ', style: Get.textTheme.bodyText1),
                          //             Text(
                          //               controller.hoveredPrice?.x.toString() ?? '---',
                          //               style: Get.textTheme.bodyText2,
                          //             ),
                          //             Text('  Ряд:y ', style: Get.textTheme.bodyText1),
                          //             Text(
                          //               controller.hoveredPrice?.y.toString() ?? '---',
                          //               style: Get.textTheme.bodyText2,
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Container(
                            width: 520,
                            height: 520,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const SizedBox(height: 0),
                                    // for (List<MarkerModel?> x in controller.grid)
                                    for (var incrX = 0; incrX < controller.grid.length; incrX++)
                                      Column(
                                        children: [
                                          // for (MarkerModel? y in x)
                                          for (var incrY = 0; incrY < controller.grid[incrX].length; incrY++)
                                            PlaceWidget(
                                              editing: edition && controller.selectedPrice != null,
                                              onHover: (marker) {
                                                controller.hoverItem(marker);
                                              },
                                              onSelect: (marker) {
                                                controller.setGridElement(
                                                  incrX,
                                                  incrY,
                                                  marker,
                                                );

                                                // log((marker?.row).toString());
                                              },
                                              currentMarker: controller.grid[incrX][incrY],
                                              marker: controller.selectedPrice,
                                              x: controller.grid[incrX][incrY].x ?? 0,
                                              y: controller.grid[incrX][incrY].y ?? 0,
                                            ),
                                        ],
                                      ),
                                    const SizedBox(height: 72),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: AppColors.LIGHT_GREEN,
                    onPressed: () {
                      // ConcertModel.update(widget.id, {
                      //   'name': widget.name,
                      //   'createdAt': widget.date,
                      //   'place': widget.place,
                      //   'row': widget.rows,
                      //   'column': widget.columns,
                      // });

                      // controller.getGridByConcertId(widget.id);
                      controller.saveGridList(widget.id);
                      // Get.to(
                      //   CreationScreen(
                      //     name: nameController.text,
                      //     date: dateController.text,
                      //     place: placeController.text,
                      //     rows: int.tryParse(xController.text) ?? 10,
                      //     columns: int.tryParse(yController.text) ?? 10,
                      //   ),
                      // );
                    },
                    label: Text(
                      'Сохранить',
                      style: Get.textTheme.bodyText1!.copyWith(color: AppColors.WHITE),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class PlaceWidget extends StatefulWidget {
  final Function(MarkerModel?) onHover;
  final Function(MarkerModel?) onSelect;
  final MarkerModel? marker;
  final MarkerModel? currentMarker;
  final bool editing;
  final int x;
  final int y;
  const PlaceWidget({
    required this.editing,
    required this.onHover,
    required this.onSelect,
    required this.x,
    required this.y,
    this.marker,
    this.currentMarker,
    Key? key,
  }) : super(key: key);
  @override
  State<PlaceWidget> createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.marker == null) {
          Get.snackbar('Внимание', 'Создай метку слева');
        } else {
          widget.onSelect(widget.marker);
        }
      },
      child: MouseRegion(
        onEnter: (event) {
          if (widget.editing) {
            if (widget.marker == null) {
              Get.snackbar('Внимание', 'Создай метку слева');
            } else {
              widget.onSelect(widget.marker);
            }
            // setState(() {
            //   currentMarker = widget.marker;
            // });
          } else {
            widget.onHover(widget.currentMarker);
          }
        },
        // onHover: (event) {

        //   widget.onHover(widget.marker);
        // },
        cursor: widget.marker?.type == null ? SystemMouseCursors.forbidden : SystemMouseCursors.grab,
        child: widget.editing
            ? SizedBox(
                height: 25,
                width: 25,
                // margin: EdgeInsets.all(0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.currentMarker?.type == null)
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          // color: widget.currentMarker?.color ?? Colors.grey,
                          border: Border.all(
                            color: widget.currentMarker?.color ?? Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'x:${widget.x + 1}',
                              style: TextStyle(color: AppColors.DARK, fontSize: 6),
                            ),
                            Text(
                              'y:${widget.y + 1}',
                              style: TextStyle(color: AppColors.DARK, fontSize: 6),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          // color: widget.currentMarker?.color ?? Colors.grey,
                          border: Border.all(
                            color: widget.currentMarker?.color ?? Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'x:${widget.x + 1}',
                              style: TextStyle(color: AppColors.DARK, fontSize: 6),
                            ),
                            Text(
                              'y:${widget.y + 1}',
                              style: TextStyle(color: AppColors.DARK, fontSize: 6),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )
            : Stack(
                children: [
                  Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: AppColors.DARK,
                    //     width: 2,
                    //   ),
                    // ),
                    height: 25,
                    width: 25,
                    // margin: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.currentMarker?.type == null)
                          Container(
                            alignment: Alignment.center,
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                              color: widget.currentMarker?.color ?? Colors.grey,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          )
                        else
                          widget.currentMarker?.type == PointType.sit
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: widget.currentMarker?.color ?? Colors.grey,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: widget.currentMarker?.color ?? Colors.grey,
                                    // borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class PlaceWidgetController extends GetxController with Utils {}



// class _PlaceWidgetState extends State<PlaceWidget> {
//   MarkerModel? currentMarker;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: MouseRegion(
//         onEnter: (event) {
//           if (widget.editing) {
//             setState(() {
//               currentMarker = widget.marker;
//             });
//           } else {
//             widget.onHover(currentMarker);
//           }
//         },
//         onHover: (event) {},
//         cursor: SystemMouseCursors.grab,
//         child: widget.editing
//             ? SizedBox(
//                 height: 25,
//                 width: 25,
//                 // margin: EdgeInsets.all(0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (currentMarker == null)
//                       Container(
//                         alignment: Alignment.center,
//                         height: 25,
//                         width: 25,
//                         decoration: BoxDecoration(
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       )
//                     else
//                       Container(
//                         alignment: Alignment.center,
//                         height: 15,
//                         width: 15,
//                         decoration: BoxDecoration(
//                           color: currentMarker?.color ?? Colors.grey,
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                       ),
//                   ],
//                 ),
//               )
//             : SizedBox(
//                 height: 25,
//                 width: 25,
//                 // margin: EdgeInsets.all(0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (currentMarker == null)
//                       Container(
//                         alignment: Alignment.center,
//                         height: 7,
//                         width: 7,
//                         decoration: BoxDecoration(
//                           color: currentMarker?.color ?? Colors.grey,
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                       )
//                     else
//                       currentMarker?.type == PointType.sit
//                           ? Container(
//                               alignment: Alignment.center,
//                               height: 15,
//                               width: 15,
//                               decoration: BoxDecoration(
//                                 color: currentMarker?.color ?? Colors.grey,
//                                 borderRadius: BorderRadius.circular(100),
//                               ),
//                             )
//                           : Container(
//                               alignment: Alignment.center,
//                               height: 25,
//                               width: 25,
//                               decoration: BoxDecoration(
//                                 color: currentMarker?.color ?? Colors.grey,
//                                 // borderRadius: BorderRadius.circular(100),
//                               ),
//                             ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
