import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/presentation/pages/login_page.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/beneficiary_page.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/tab_page.dart';
import 'package:top_up_beneficiary_app/app/features/credits/presentation/credit_page.dart';
import 'package:top_up_beneficiary_app/app/features/credits/presentation/cubit/credit_cubit.dart';
import 'package:top_up_beneficiary_app/core/design_system/top_up_button.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInitialCredit();
    });
  }

  void checkInitialCredit() async {
    final sharedPrefs = SharedPreferencesService();
    var beneficiaries = await sharedPrefs.getBeneficiaries();
    if (beneficiaries.isEmpty) {
      // In the first run, add 5000 credits to the user
      GetIt.instance<CreditCubit>().addCredit(5000.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationCubit>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Top Up Beneficiary App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Daves Balthazar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Lottie.asset(
                'assets/lottie/lottie_credit.json',
                height: 260,
              ),
              const CreditPage(),
              const Text(
                  'You will be able to add a maximum of 5 active top-up beneficiaries.\n'
                  'Manage your beneficiaries UAE phone numbers and distribute credits to make local calls.\n'
                  'Easy and fast.\n'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TopUpButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BeneficiaryPage()),
                        );
                      },
                      label: 'Manage Beneficiaries'),
                  TopUpButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TabPage()),
                        );
                      },
                      label: 'Recharge'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
