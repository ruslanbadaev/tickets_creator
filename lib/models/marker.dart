import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tickets/models/result.dart';
import 'package:tickets/pages/creation/controller.dart';

class MarkerModel {
  final String id;
  final String concertId;
  final int? row;
  final int? column;
  String name;
  Color color;
  String? price;
  String? createdAt;
  PointType? type;
  MarkerModel({
    required this.id,
    required this.concertId,
    required this.name,
    required this.color,
    this.row,
    this.column,
    this.price,
    this.createdAt,
    this.type,
  });

  static Map<String, dynamic> toJson(MarkerModel price) {
    return {
      'id': price.id,
      'name': price.name,
      'color': price.color,
      'type': price.type,
      'price': price.price,
      'createdAt': price.createdAt,
      'row': price.row,
      'column': price.column,
    };
  }

  static Future<MarkerModel> fromJson(Map<String, dynamic> json) async {
    return MarkerModel(
      id: json['id'] ?? '??',
      concertId: json['concertId'] ?? '??',
      name: json['name'] ?? '??',
      color: Color(json['color']),
      type: PointType.values.byName(json['type']),
      price: json['price'] ?? '??',
      createdAt: json['createdAt'] ?? '??',
      row: json['row'] ?? 10,
      column: json['column'] ?? 10,
    );
  }

  static Future<ResultModel> save(Map<String, dynamic> json, {required bool toGrid}) async {
    try {
      final collection = FirebaseFirestore.instance.collection(toGrid ? 'grid' : 'markers');
      json['createdAt'] = DateTime.now().toString();
      await collection.doc().set(json, SetOptions());

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

  static Future<ResultModel> merge(Map<String, dynamic> json, {required bool toGrid}) async {
    try {
      final collection = FirebaseFirestore.instance.collection(toGrid ? 'grid' : 'markers');
      json['createdAt'] = DateTime.now().toString();
      await collection.doc().set(json, SetOptions(merge: true));

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

  static Future<ResultModel?> getAll({required bool toGrid}) async {
    try {
      final db = FirebaseFirestore.instance;
      Query<Map<String, dynamic>>? data;
      List<MarkerModel> allResults = [];
      data = db.collection(toGrid ? 'grid' : 'markers').orderBy('createdAt');

      var documentSnapshots = await data.get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in documentSnapshots.docs) {
        ResultModel result = await MarkerModel.fromFirestore(element, SnapshotOptions());
        if (result.status == ResultStatus.success && result.data != null) {
          try {
            allResults.add(result.data as MarkerModel);
            // log((result.data as MarkerModel).toString(), name: 'ppp');
            // log(allResults.toString(), name: 'allResults');
          } catch (e) {
            log(e.toString(), name: '11551132');
          }
        } else {
          // Get.defaultDialog(content: Text(ResultModel.parseError(result.message)));
        }
      }

      return ResultModel(
        data: allResults,
        status: ResultStatus.success,
      );
    } catch (e) {
      return ResultModel(
        status: ResultStatus.error,
        message: e.toString(),
      );
    }
  }

  static Future<ResultModel> get({required bool toGrid}) async {
    try {
      ResultModel? result;
      final db = FirebaseFirestore.instance;
      DocumentReference<Map<String, dynamic>> data;

      data = db.collection(toGrid ? 'grid' : 'markers').doc();

      data.get().then(
        (documentSnapshots) async {
          result = await MarkerModel.fromFirestore(documentSnapshots, SnapshotOptions());

          log(result!.data.toString());
        },
        onError: (e) => print("Error completing: $e"),
      );

      return ResultModel(
        data: result,
        status: ResultStatus.success,
      );
    } catch (e) {
      return ResultModel(
        status: ResultStatus.error,
        message: e.toString(),
      );
    }
  }

  static Future<ResultModel> fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) async {
    try {
      final data = snapshot.data();
      log(data.toString());
      if (data == null) {
        throw 'MarkerModel fromFirestore';
      }
      return ResultModel(status: ResultStatus.success, data: MarkerModel.fromJson(data)

          // (
          //   // id: data?['id'] ?? '??',
          //   id: snapshot.id,
          //   name: data?['name'] ?? '??',
          //   concertId: 'No',
          //   color: data?['color'] ?? '??',
          //   row: data?['row'] ?? '??',
          //   column: data?['column'] ?? '??',
          // ),
          );
    } catch (e) {
      log(e.toString());
      return ResultModel(
        status: ResultStatus.error,
        message: e.toString(),
      );
    }
  }

  static Future<ResultModel> update(String id, Map<String, dynamic> json, {required bool toGrid}) async {
    try {
      log(id.toString());
      final collection = FirebaseFirestore.instance.collection(toGrid ? 'grid' : 'markers');
      await collection.doc(id).update(json);

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

  static Future<ResultModel> delete(String id, {required bool toGrid}) async {
    try {
      log(id.toString());
      final collection = FirebaseFirestore.instance.collection(toGrid ? 'grid' : 'markers');
      await collection.doc(id).delete();

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
      MarkerModel{
        id: $id, 
        name: $name, 
        concertId: $concertId, 
        row: $row,
        column: $column,
        color: $color,
        price: $price,
        createdAt: $createdAt,
        type: $type,
      }
      ''';
  }
}
