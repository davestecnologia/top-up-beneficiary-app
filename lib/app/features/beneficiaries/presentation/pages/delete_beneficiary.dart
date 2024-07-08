import 'package:flutter/material.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class DeleteBeneficiaryPage extends StatelessWidget {
  DeleteBeneficiaryPage({super.key, required this.beneficiary});

  final Beneficiary beneficiary;
  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Beneficiary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Are you sure you want to delete ${beneficiary.nickname}?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<Beneficiary> beneficiaries =
                    await _sharedPrefs.getBeneficiaries();
                beneficiaries.removeWhere((b) => b.id == beneficiary.id);
                await _sharedPrefs.saveBeneficiaries(beneficiaries);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
