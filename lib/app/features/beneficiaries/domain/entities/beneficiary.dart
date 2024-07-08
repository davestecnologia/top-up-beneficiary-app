class Beneficiary {
  final String id;
  final String nickname;
  final String phoneNumber;
  final bool isVerified;
  final double monthlyTopUpAmount;

  Beneficiary({
    required this.id,
    required this.nickname,
    required this.phoneNumber,
    required this.isVerified,
    this.monthlyTopUpAmount = 0.0,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) => Beneficiary(
        id: json['id'],
        nickname: json['nickname'],
        phoneNumber: json['phoneNumber'],
        isVerified: json['isVerified'],
        monthlyTopUpAmount: json['monthlyTopUpAmount'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'isVerified': isVerified,
        'monthlyTopUpAmount': monthlyTopUpAmount,
      };
}
