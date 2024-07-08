import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';

class BeneficiaryModel extends Beneficiary {
  BeneficiaryModel({
    required super.id,
    required super.nickname,
    required super.phoneNumber,
    required super.isVerified,
    super.monthlyTopUpAmount,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      isVerified: json['isVerified'],
      monthlyTopUpAmount: json['monthlyTopUpAmount'] ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'monthlyTopUpAmount': monthlyTopUpAmount,
    };
  }
}
