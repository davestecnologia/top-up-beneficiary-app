import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_up_beneficiary_app/app/features/credits/presentation/cubit/credit_cubit.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<CreditCubit>()..loadCredits(),
      child: BlocBuilder<CreditCubit, CreditState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return Column(
              children: [
                Text(
                  'Credits: \$${state.credits}',
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<CreditCubit>().addCredit(10.0);
                      },
                      child: const Text('Add 10 Credits'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CreditCubit>().useCredit(5.0);
                      },
                      child: const Text('Use 5 Credits'),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
