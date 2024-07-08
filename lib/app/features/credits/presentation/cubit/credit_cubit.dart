import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_up_beneficiary_app/app/features/credits/domain/usecases/add_credit_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/credits/domain/usecases/use_credit_usecase.dart';

class CreditState {
  final double credits;
  final bool isLoading;
  final String? error;

  CreditState({required this.credits, this.isLoading = false, this.error});
}

class CreditCubit extends Cubit<CreditState> {
  final AddCreditUseCase addCreditUseCase;
  final UseCreditUseCase useCreditUseCase;

  CreditCubit(this.addCreditUseCase, this.useCreditUseCase)
      : super(CreditState(credits: 0.0));

  void loadCredits() async {
    emit(CreditState(credits: state.credits, isLoading: true));
    try {
      final currentCredits = await _getCurrentCredits();
      emit(CreditState(credits: currentCredits));
    } catch (e) {
      emit(CreditState(credits: state.credits, error: e.toString()));
    }
  }

  void addCredit(double amount) async {
    emit(CreditState(credits: state.credits, isLoading: true));
    try {
      await addCreditUseCase.execute(amount);
      final updatedCredits = await _getCurrentCredits();
      emit(CreditState(credits: updatedCredits));
    } catch (e) {
      emit(CreditState(credits: state.credits, error: e.toString()));
    }
  }

  void useCredit(double amount) async {
    emit(CreditState(credits: state.credits, isLoading: true));
    try {
      await useCreditUseCase.execute(amount);
      final updatedCredits = await _getCurrentCredits();
      emit(CreditState(credits: updatedCredits));
    } catch (e) {
      emit(CreditState(credits: state.credits, error: e.toString()));
    }
  }

  Future<double> _getCurrentCredits() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble('credits') ?? 0.0;
  }
}
