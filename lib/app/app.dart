import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/presentation/pages/login_page.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/repositories/repositories.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/get_beneficiaries_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/save_beneficiaries_usecase.dart:.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/data/repositories/beneficiary_repository_impl.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/cubit/beneficiary_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/credits/domain/usecases/add_credit_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/credits/domain/usecases/use_credit_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/credits/presentation/cubit/credit_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BeneficiaryRepository>(
          create: (context) => BeneficiaryRepositoryImpl(),
        ),
        RepositoryProvider<GetBeneficiariesUseCase>(
          create: (context) => GetBeneficiariesUseCase(
            context.read<BeneficiaryRepository>(),
          ),
        ),
        RepositoryProvider<SaveBeneficiariesUseCase>(
          create: (context) => SaveBeneficiariesUseCase(
            context.read<BeneficiaryRepository>(),
          ),
        ),
        RepositoryProvider<AddCreditUseCase>(
          create: (context) => AddCreditUseCase(),
        ),
        RepositoryProvider<UseCreditUseCase>(
          create: (context) => UseCreditUseCase(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GetIt.instance<AuthenticationCubit>()),
          BlocProvider(create: (_) => GetIt.instance<BeneficiaryCubit>()),
          BlocProvider(create: (_) => GetIt.instance<CreditCubit>()),
        ],
        child: MaterialApp(
          title: 'Top Up Beneficiary App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}
