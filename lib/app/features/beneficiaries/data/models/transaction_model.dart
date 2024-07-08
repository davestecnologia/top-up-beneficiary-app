enum TransactionType { credit, fee }

class TransactionModel {
  final String beneficiaryId;
  final String beneficiaryNickname;
  final TransactionType type;
  final DateTime date;
  final double value;

  TransactionModel({
    required this.beneficiaryId,
    required this.beneficiaryNickname,
    required this.type,
    required this.date,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'beneficiaryId': beneficiaryId,
      'beneficiaryNickname': beneficiaryNickname,
      'type': type == TransactionType.credit ? 'credit' : 'fee',
      'date': date.toIso8601String(),
      'value': value,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      beneficiaryId: json['beneficiaryId'],
      beneficiaryNickname: json['beneficiaryNickname'],
      type: json['type'] == 'credit'
          ? TransactionType.credit
          : TransactionType.fee,
      date: DateTime.parse(json['date']),
      value: json['value'],
    );
  }
}
