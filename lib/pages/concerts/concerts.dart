import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tickets/utils/theme/app_text_theme.dart';

import '../../mixins/utils.dart';
import '../../models/concert.dart';
import '../../utils/constants/colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/lite_loading_screen.dart';
import '../creation/creation.dart';
import 'controller.dart';

class ConcertsScreen extends StatefulWidget {
  const ConcertsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConcertsScreenState createState() => ConcertsScreenState();
}

class ConcertsScreenState extends State<ConcertsScreen> with TickerProviderStateMixin, Utils {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController xController = TextEditingController();
  TextEditingController yController = TextEditingController();

  @override
  void initState() {
    dateController = TextEditingController(text: DateTime.now().toString());

    super.initState();
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
                appBar: const CustomAppBar(
                  titleString: 'Концерты',
                  isShowBack: false,
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 600,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Text(
                              'Мои концерты:',
                              style: Get.textTheme.headline3Bold,
                            ),
                            const SizedBox(height: 16),
                            for (ConcertModel concert in controller.allConcerts)
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        CreationScreen(
                                          id: concert.id,
                                          name: concert.name,
                                          date: concert.createdAt.toString(),
                                          place: concert.place,
                                          rows: int.tryParse(concert.row ?? '') ?? 10,
                                          columns: int.tryParse(concert.column ?? '') ?? 10,
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 400,
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        color: AppColors.WHITE,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          alignment: Alignment.center,
                                          height: 64,
                                          child: Row(
                                            children: [
                                              Text(
                                                concert.name,
                                                style: Get.textTheme.bodyText1,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                concert.createdAt.toString(),
                                                style: Get.textTheme.bodyText2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await ConcertModel.delete(concert.id);
                                      await controller.getAllItems();
                                    },
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
                      ),
                    ),
                    const SizedBox(width: 48),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Новый концерт:',
                          style: Get.textTheme.headline3Bold,
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
                                        controller: nameController,
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
                                    InkWell(
                                      onTap: () {
                                        Get.defaultDialog(
                                          content: SizedBox(
                                            // height: 500,
                                            // width: 500,
                                            child: DateTimePicker(
                                              // controller: dateController,
                                              style: Get.textTheme.bodyText1,
                                              type: DateTimePickerType.dateTimeSeparate,
                                              dateMask: 'd MMM, yyyy',
                                              initialValue: DateTime.now().toString(),
                                              firstDate: DateTime(2023),
                                              lastDate: DateTime(2043),
                                              icon: const Icon(Icons.event),
                                              dateLabelText: 'Дата',
                                              timeLabelText: "Время",
                                              // selectableDayPredicate: (date) {
                                              //   // // Disable weekend days to select from the calendar
                                              //   // if (date.weekday == 6 || date.weekday == 7) {
                                              //   //   return false;
                                              //   // }

                                              //   // return true;
                                              // },

                                              onChanged: (val) {
                                                dateController.text = val;
                                                setState(() {});
                                              },
                                              validator: (val) {
                                                print(val);
                                                return null;
                                              },
                                              onSaved: (val) => {
                                                log(val.toString(), name: 'save'),
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        color: Colors.grey[200],
                                        width: 200,
                                        height: 36,
                                        child: TextField(
                                          controller: dateController,
                                          enabled: false,
                                          textAlignVertical: TextAlignVertical.center,
                                          maxLines: 1,
                                          style: Get.textTheme.bodyText2,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
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
                                        controller: placeController,
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
                                        controller: xController,
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
                                        controller: yController,
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
                                const SizedBox(height: 24),
                                FloatingActionButton.extended(
                                  backgroundColor: AppColors.LIGHT_GREEN,
                                  onPressed: () async {
                                    controller.save({
                                      // 'id': const Uuid().v4(),
                                      'name': nameController.text,
                                      'createdAt': DateTime.now().toString(),
                                      'date': dateController.text,
                                      'place': placeController.text,
                                      'row': xController.text,
                                      'column': yController.text,
                                    });
                                  },
                                  label: Text(
                                    'Создать',
                                    style: Get.textTheme.bodyText1!.copyWith(color: AppColors.WHITE),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // floatingActionButton: FloatingActionButton(onPressed: () {}),
              );
      },
    );
  }
}

// String minusOne(String value) {
//   String result = '9';
//   if (int.tryParse(value) != null) {
//     result = (int.parse(value) - 1).toString();
//   }
//   return result;
// }

class PlaceWidgetController extends GetxController with Utils {}
