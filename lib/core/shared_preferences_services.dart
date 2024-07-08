import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/data/models/transaction_model.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';

class SharedPreferencesService {
  static const _key = 'beneficiaries';

  Future<List<Beneficiary>> getBeneficiaries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      return List<Beneficiary>.from(
          json.decode(jsonString).map((x) => Beneficiary.fromJson(x)));
    } else {
      return [];
    }
  }

  Future<void> saveBeneficiaries(List<Beneficiary> beneficiaries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(beneficiaries);
    await prefs.setString(_key, jsonString);
  }

  Future<List<TransactionModel>> getTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsString = prefs.getString('transactions');
    if (transactionsString != null) {
      List<dynamic> transactionList = jsonDecode(transactionsString);
      return transactionList.map((t) => TransactionModel.fromJson(t)).toList();
    }
    return [];
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String transactionsString =
        jsonEncode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString('transactions', transactionsString);
  }
}
