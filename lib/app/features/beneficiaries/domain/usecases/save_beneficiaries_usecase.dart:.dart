import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/repositories/repositories.dart';

class SaveBeneficiariesUseCase {
  final BeneficiaryRepository repository;

  SaveBeneficiariesUseCase(this.repository);

  Future<void> call(List<Beneficiary> beneficiaries) async {
    await repository.saveBeneficiaries(beneficiaries);
  }
}
