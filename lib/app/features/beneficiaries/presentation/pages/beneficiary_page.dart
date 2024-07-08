import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/get_beneficiaries_usecase.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/usecases/save_beneficiaries_usecase.dart:.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/edit_beneficiary_page.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/create_beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/cubit/beneficiary_cubit.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class BeneficiaryPage extends StatelessWidget {
  const BeneficiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BeneficiaryCubit(
        context.read<GetBeneficiariesUseCase>(),
        context.read<SaveBeneficiariesUseCase>(),
      )..loadBeneficiaries(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Beneficiaries'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _navigateToCreateBeneficiary(context);
              },
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) =>
              GetIt.instance<BeneficiaryCubit>()..loadBeneficiaries(),
          child: BlocBuilder<BeneficiaryCubit, BeneficiaryState>(
            // bloc: context.read<BeneficiaryCubit>(),
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.error != null) {
                return Center(
                    child:
                        Text('Failed to load beneficiaries: ${state.error}'));
              } else if (state.beneficiaries.isEmpty) {
                return const Center(child: Text('No beneficiaries available.'));
              } else {
                return ListView.builder(
                  itemCount: state.beneficiaries.length,
                  itemBuilder: (context, index) {
                    final beneficiary = state.beneficiaries[index];
                    return ListTile(
                      title: Text(beneficiary.nickname),
                      subtitle: Text(beneficiary.phoneNumber),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _navigateToEditBeneficiary(context, beneficiary);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmationDialog(
                                  context, beneficiary);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _navigateToCreateBeneficiary(BuildContext context) async {
    final SharedPreferencesService sharedPrefs = SharedPreferencesService();

    List<Beneficiary> beneficiaries = await sharedPrefs.getBeneficiaries();
    if (beneficiaries.length < 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateBeneficiaryPage(
                  onCreated: () {
                    context.read<BeneficiaryCubit>().loadBeneficiaries();
                  },
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 5 beneficiaries reached')),
      );
    }
  }

  void _navigateToEditBeneficiary(
      BuildContext context, Beneficiary beneficiary) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditBeneficiaryPage(
              beneficiary: beneficiary,
              onEdit: () {
                context.read<BeneficiaryCubit>().loadBeneficiaries();
              }),
        ));
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Beneficiary beneficiary) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Beneficiary'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete ${beneficiary.nickname}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                context
                    .read<BeneficiaryCubit>()
                    .deleteBeneficiary(beneficiary)
                    .then((_) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
