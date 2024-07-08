import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/data/models/transaction_model.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/app/features/credits/presentation/cubit/credit_cubit.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class TopUpScreen extends StatefulWidget {
  final Beneficiary beneficiary;

  const TopUpScreen({super.key, required this.beneficiary});

  @override
  TopUpScreenState createState() => TopUpScreenState();
}

class TopUpScreenState extends State<TopUpScreen> {
  double _selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top-Up ${widget.beneficiary.nickname}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Top-Up Amount:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTopUpOptions(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedAmount > 0 ? _performTopUp : null,
              child: const Text('Confirm Top-Up'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpOptions() {
    return Column(
      children: [
        _buildTopUpOptionButton(5),
        _buildTopUpOptionButton(10),
        _buildTopUpOptionButton(20),
        _buildTopUpOptionButton(30),
        _buildTopUpOptionButton(50),
        _buildTopUpOptionButton(75),
        _buildTopUpOptionButton(100),
      ],
    );
  }

  Widget _buildTopUpOptionButton(double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedAmount = amount;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedAmount == amount ? Colors.blue : null,
        ),
        child: Text('AED $amount'),
      ),
    );
  }

  void _performTopUp() async {
    // Fetch transactions from SharedPreferencesService
    final SharedPreferencesService sharedPrefs = SharedPreferencesService();
    List<TransactionModel> transactions = await sharedPrefs.getTransactions();

    // Determine maximum top-up amount based on user verification status
    double maxTopUpAmountPerBeneficiary = 0;
    if (widget.beneficiary.isVerified) {
      maxTopUpAmountPerBeneficiary =
          500; // AED 500 per calendar month per beneficiary for verified users
    } else {
      maxTopUpAmountPerBeneficiary =
          1000; // AED 1000 per calendar month per beneficiary for non-verified users
    }

    // Check if adding this transaction exceeds the monthly limit
    double totalTopUpThisMonth = 0;
    for (TransactionModel transaction in transactions) {
      if (transaction.beneficiaryId == widget.beneficiary.id &&
          transaction.date.month == DateTime.now().month &&
          transaction.date.year == DateTime.now().year) {
        totalTopUpThisMonth += transaction.value;
      }
    }

    // Calculate remaining allowance for this month
    double remainingAllowance =
        maxTopUpAmountPerBeneficiary - totalTopUpThisMonth;

    if (_selectedAmount > remainingAllowance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Exceeded monthly top-up limit for ${widget.beneficiary.nickname}!'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Use CreditCubit to deduct credit (assuming this is implemented elsewhere)
    context.read<CreditCubit>().useCredit(_selectedAmount);

    // Use 1 credit for every AED 1 top-up
    context.read<CreditCubit>().useCredit(1);

    // Add new transaction
    transactions.add(TransactionModel(
      beneficiaryId: widget.beneficiary.id,
      beneficiaryNickname: widget.beneficiary.nickname,
      type: TransactionType.credit,
      date: DateTime.now(),
      value: _selectedAmount,
    ));

    transactions.add(TransactionModel(
      beneficiaryId: widget.beneficiary.id,
      beneficiaryNickname: widget.beneficiary.nickname,
      type: TransactionType.fee,
      date: DateTime.now(),
      value: 1,
    ));

    // Save updated transactions to SharedPreferences
    await sharedPrefs.saveTransactions(transactions);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Top-Up of AED $_selectedAmount successful for ${widget.beneficiary.nickname}!',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
