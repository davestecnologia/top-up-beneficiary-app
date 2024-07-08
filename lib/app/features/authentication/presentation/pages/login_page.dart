import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:top_up_beneficiary_app/app/features/authentication/presentation/bloc/authentication_cubit.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/presentation/pages/home_page.dart';
import 'package:top_up_beneficiary_app/core/design_system/top_up_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid credentials')));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight),
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
                    height: 180,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Fill in your login and password to access your account.',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  RichText(
                    text: const TextSpan(
                      text: 'For this DEMO VERSION: use ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors
                            .black, // Ensure the text color is set to something visible
                      ),
                      children: [
                        TextSpan(
                          text: '"user"',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                        ),
                        TextSpan(
                          text: '"password"',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' in the fields below for login.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureText,
                  ),
                  const SizedBox(height: 20),
                  TopUpButton(
                    onTap: () {
                      final username = usernameController.text;
                      final password = passwordController.text;
                      context
                          .read<AuthenticationCubit>()
                          .login(username, password);
                    },
                    label: 'Login',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
