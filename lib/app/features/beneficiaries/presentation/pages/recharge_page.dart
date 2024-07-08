import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/get_beneficiaries_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/save_beneficiaries_usecase.dart:.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/cubit/beneficiary_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/top_up_page.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/wigets/beneficiary_card.dart';

class RechargePage extends StatelessWidget {
  const RechargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeneficiaryCubit(
        context.read<GetBeneficiariesUseCase>(),
        context.read<SaveBeneficiariesUseCase>(),
      )..loadBeneficiaries(),
      // create: (context) =>
      //     GetIt.instance<BeneficiaryCubit>()..loadBeneficiaries(),
      child: const BeneficiaryList(),
    );
  }
}

class BeneficiaryList extends StatelessWidget {
  const BeneficiaryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeneficiaryCubit, BeneficiaryState>(
      bloc: context.read<BeneficiaryCubit>(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: state.beneficiaries.length,
            itemBuilder: (context, index) {
              final beneficiary = state.beneficiaries[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BeneficiaryCard(
                    beneficiary: beneficiary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TopUpScreen(beneficiary: beneficiary),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
