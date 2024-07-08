import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/repositories/repositories.dart';

class GetBeneficiariesUseCase {
  final BeneficiaryRepository repository;

  GetBeneficiariesUseCase(this.repository);

  Future<List<Beneficiary>> execute() async {
    return await repository.getBeneficiaries();
  }
}
