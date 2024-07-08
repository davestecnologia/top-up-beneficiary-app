import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/repositories/repositories.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/data/models/beneficiary_model.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  @override
  Future<List<Beneficiary>> getBeneficiaries() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 1));
    final beneficiariesString = prefs.getString('beneficiaries');
    if (beneficiariesString != null) {
      final List<dynamic> beneficiariesJson = json.decode(beneficiariesString);
      return beneficiariesJson
          .map((json) => BeneficiaryModel.fromJson(json))
          .toList();
    } else {
      // In first run, we will save some mocked beneficiaries
      final mockedBeneficiaries = _getMockedBeneficiaries();
      saveBeneficiaries(mockedBeneficiaries);

      // In the first run, add 5000 credits to the user
      // GetIt.instance<CreditCubit>().addCredit(5000.0);

      return mockedBeneficiaries;
    }
  }

  @override
  Future<void> saveBeneficiaries(List<Beneficiary> beneficiaries) async {
    final prefs = await SharedPreferences.getInstance();
    final beneficiariesJson = json.encode(beneficiaries
        .map((b) => BeneficiaryModel(
              id: b.id,
              nickname: b.nickname,
              phoneNumber: b.phoneNumber,
              isVerified: b.isVerified,
              monthlyTopUpAmount: b.monthlyTopUpAmount,
            ).toJson())
        .toList());
    await prefs.setString('beneficiaries', beneficiariesJson);
  }

  List<Beneficiary> _getMockedBeneficiaries() {
    return [
      BeneficiaryModel(
        id: '1',
        nickname: 'Amit Pahandit',
        phoneNumber: '+915255219205',
        isVerified: true,
        monthlyTopUpAmount: 50.0,
      ),
      BeneficiaryModel(
        id: '2',
        nickname: 'Kumar Suresh',
        phoneNumber: '+971562194020',
        isVerified: false,
        monthlyTopUpAmount: 30.0,
      ),
      BeneficiaryModel(
        id: '3',
        nickname: 'Daves Balthazar',
        phoneNumber: '+5511992825958',
        isVerified: false,
        monthlyTopUpAmount: 20.0,
      ),
      BeneficiaryModel(
        id: '4',
        nickname: 'André Shigemori',
        phoneNumber: '+971504932165',
        isVerified: true,
        monthlyTopUpAmount: 45.0,
      ),
    ];
  }
}
