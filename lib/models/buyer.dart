class BuyerModel {
  final String id;
  final String name;
  final String status;
  final DateTime? createdAt;

  BuyerModel({
    required this.id,
    required this.name,
    required this.status,
    this.createdAt,
  });

  static BuyerModel fromJson(Map<String, dynamic> json) {
    return BuyerModel(
      id: (json['id']) ?? '?',
      name: json['name'] ?? '??',
      status: json['status'] ?? '??',
      createdAt: DateTime.tryParse((json['createdAt'] ?? '')),
    );
  }

  @override
  String toString() {
    return '''
      BuyerModel{
        id: $id, 
        name: $name, 
        status: $status,
        createdAt: $createdAt,
      }
      ''';
  }
}
