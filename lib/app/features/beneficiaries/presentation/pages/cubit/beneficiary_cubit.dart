import 'package:bloc/bloc.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/get_beneficiaries_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/save_beneficiaries_usecase.dart:.dart';

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

class BeneficiaryCubit extends Cubit<BeneficiaryState> {
  final GetBeneficiariesUseCase getBeneficiariesUseCase;
  final SaveBeneficiariesUseCase saveBeneficiariesUseCase;

  BeneficiaryCubit(this.getBeneficiariesUseCase, this.saveBeneficiariesUseCase)
      : super(BeneficiaryState(beneficiaries: []));

  Future<void> loadBeneficiaries() async {
    emit(state.copyWith(isLoading: true));
    try {
      final beneficiaries = await getBeneficiariesUseCase.execute();
      emit(state.copyWith(beneficiaries: beneficiaries, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    emit(state.copyWith(isLoading: true));
    try {
      final beneficiaries = List<Beneficiary>.from(state.beneficiaries)
        ..add(beneficiary);
      await saveBeneficiariesUseCase.call(beneficiaries);
      emit(state.copyWith(beneficiaries: beneficiaries, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteBeneficiary(Beneficiary beneficiary) async {
    emit(state.copyWith(isLoading: true));
    try {
      final beneficiaries = List<Beneficiary>.from(state.beneficiaries)
        ..remove(beneficiary);
      await saveBeneficiariesUseCase.call(beneficiaries);
      emit(state.copyWith(beneficiaries: beneficiaries, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
