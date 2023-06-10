import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../mixins/utils.dart';
import '../../models/marker.dart';
import '../../models/price.dart';

enum PointType { sit, sector, object }

class CreationScreenController extends GetxController with Utils {
  MarkerModel? _selectedPrice;
  PointType? _pointType;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<List<MarkerModel?>> grid = [];

  List<MarkerModel> prices = [];

  MarkerModel? get selectedPrice => _selectedPrice;
  PointType? get pointType => _pointType;

  @override
  void onReady() {
    super.onReady();
    generateGrid(20, 20);
  }

  void generateGrid(int x, int y) {
    int incrX = 0;
    grid.clear();
    while (incrX < x) {
      grid.add([]);
      int incrY = 0;
      while (incrY < y) {
        grid[incrX].add(
          MarkerModel(
            id: '0',
            name: 'x:$incrX|y:$incrY',
            color: Colors.grey,
          ),
        );
        incrY++;
      }
      incrX++;
    }
    update();
  }

  setGridElement(int x, int y, MarkerModel? value) {
    grid[x][y] = value;
    update();
  }

  void selectPrice(MarkerModel price) {
    _selectedPrice = price;

    update();
  }

  void createPrice(MarkerModel price) {
    prices.add(price);
    nameController.clear();
    priceController.clear();
    _pointType = null;
    selectPrice(price);
    update();
  }

  void removePrice(MarkerModel price) {
    prices.remove(price);
    update();
  }

  void selectPointType(PointType type) {
    log(type.toString());
    _pointType = type;
    update();
  }
}
