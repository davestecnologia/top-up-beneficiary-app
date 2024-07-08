import 'package:shared_preferences/shared_preferences.dart';

class UseCreditUseCase {
  UseCreditUseCase();

  Future<void> execute(double amount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final currentCredits = sharedPreferences.getDouble('credits') ?? 0.0;
    if (currentCredits >= amount) {
      sharedPreferences.setDouble('credits', currentCredits - amount);
    } else {
      throw Exception('Insufficient credits');
    }
  }
}
