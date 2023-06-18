import 'package:flutter/material.dart';
import 'package:tickets/models/result.dart';
import 'package:tickets/pages/creation/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConcertModel {
  final String id;
  final int? row;
  final int? column;
  String name;
  Color color;
  String? price;
  PointType? type;
  ConcertModel({
    required this.id,
    required this.name,
    required this.color,
    this.row,
    this.column,
    this.price,
    this.type,
  });

  static Future<ResultModel> save(Map<String, dynamic> json) async {
    try {
      final collection = FirebaseFirestore.instance.collection('concerts');
      final data = <String, dynamic>{
        'test1': 'test2',
        'test2': 'test2',
      };
      await collection.doc().set(data);

      return ResultModel(
        status: ResultStatus.success,
      );
    } catch (e) {
      return ResultModel(
        status: ResultStatus.error,
        message: e.toString(),
      );
    }
  }

  @override
  String toString() {
    return '''
      Recipient{
        id: $id, 
        name: $name, 
        row: $row,
        column: $column,
        color: $color,
        price: $price,
        type: $type,
      }
      ''';
  }
}
