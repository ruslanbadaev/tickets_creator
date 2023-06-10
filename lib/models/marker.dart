import 'package:flutter/material.dart';
import 'package:tickets/pages/creation/controller.dart';

class MarkerModel {
  final String id;
  final String name;

  final int row;
  final int column;
  final Color color;
  final String? price;
  final PointType? type;
  MarkerModel({
    required this.id,
    required this.name,
    required this.color,
    required this.row,
    required this.column,
    this.price,
    this.type,
  });
}
