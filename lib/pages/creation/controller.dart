import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/utils.dart';
import '../../models/price.dart';

enum PointType { sit, sector, object }

class CreationScreenController extends GetxController with Utils {
  PriceModel? _selectedPrice;
  PointType? _pointType;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<PriceModel> prices = [];

  PriceModel? get selectedPrice => _selectedPrice;
  PointType? get pointType => _pointType;

  void selectPrice(PriceModel price) {
    _selectedPrice = price;

    update();
  }

  void createPrice(PriceModel price) {
    prices.add(price);
    nameController.clear();
    priceController.clear();
    _pointType = null;
    selectPrice(price);
    update();
  }

  void removePrice(PriceModel price) {
    prices.remove(price);
    update();
  }

  void selectPointType(PointType type) {
    log(type.toString());
    _pointType = type;
    update();
  }
}
