import 'package:shared_preferences/shared_preferences.dart';

class AddCreditUseCase {
  AddCreditUseCase();

  Future<void> execute(double amount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final currentCredits = sharedPreferences.getDouble('credits') ?? 0.0;
    sharedPreferences.setDouble('credits', currentCredits + amount);
  }
}
