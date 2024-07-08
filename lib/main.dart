import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:top_up_beneficiary_app/app/app.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/data/repositories/user_repositorie_implementation.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/domain/repositories/autenthication_repository.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/repositories/repositories.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/get_beneficiaries_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/save_beneficiaries_usecase.dart:.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/data/repositories/beneficiary_repository_impl.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/cubit/beneficiary_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/credits/domain/usecases/add_credit_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/credits/domain/usecases/use_credit_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/credits/presentation/cubit/credit_cubit.dart';

void main() {
  final getIt = GetIt.instance;

  // Registering dependencies
  getIt.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl());
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<AuthenticationCubit>(
      () => AuthenticationCubit(getIt()));

  getIt.registerLazySingleton<BeneficiaryRepository>(
      () => BeneficiaryRepositoryImpl());
  getIt.registerLazySingleton<GetBeneficiariesUseCase>(
      () => GetBeneficiariesUseCase(getIt()));
  getIt.registerLazySingleton<SaveBeneficiariesUseCase>(
      () => SaveBeneficiariesUseCase(getIt()));
  getIt.registerLazySingleton<BeneficiaryCubit>(
      () => BeneficiaryCubit(getIt(), getIt()));

  getIt.registerLazySingleton<AddCreditUseCase>(() => AddCreditUseCase());
  getIt.registerLazySingleton<UseCreditUseCase>(() => UseCreditUseCase());

  getIt.registerLazySingleton<CreditCubit>(() => CreditCubit(
        getIt<AddCreditUseCase>(),
        getIt<UseCreditUseCase>(),
      ));

  runApp(const App());
}
