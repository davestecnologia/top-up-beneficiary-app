import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';

class BeneficiaryState {
  final List<Beneficiary> beneficiaries;
  final bool isLoading;
  final String? error;

  BeneficiaryState({
    required this.beneficiaries,
    this.isLoading = false,
    this.error,
  });

  BeneficiaryState copyWith({
    List<Beneficiary>? beneficiaries,
    bool? isLoading,
    String? error,
  }) {
    return BeneficiaryState(
      beneficiaries: beneficiaries ?? this.beneficiaries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
