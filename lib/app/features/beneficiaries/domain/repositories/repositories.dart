import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';

abstract class BeneficiaryRepository {
  Future<List<Beneficiary>> getBeneficiaries();
  Future<void> saveBeneficiaries(List<Beneficiary> beneficiaries);
}
