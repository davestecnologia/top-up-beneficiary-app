import 'package:flutter/material.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/data/models/transaction_model.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<List<TransactionModel>> _fetchTransactions() async {
    final SharedPreferencesService sharedPrefs = SharedPreferencesService();
    return await sharedPrefs.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionModel>>(
      future: _fetchTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading transactions'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions found'));
        } else {
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(
                    'Beneficiary: ${transaction.beneficiaryId} - ${transaction.beneficiaryNickname}'),
                subtitle: Text(
                    'Date: ${transaction.date}\nValue: AED ${transaction.value.toStringAsFixed(2)} - ${transaction.type.toString().split('.').last}'),
              );
            },
          );
        }
      },
    );
  }
}
