import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class CreateBeneficiaryPage extends StatefulWidget {
  const CreateBeneficiaryPage({this.onCreated, super.key});

  final Function()? onCreated;

  @override
  CreateBeneficiaryPageState createState() => CreateBeneficiaryPageState();
}

class CreateBeneficiaryPageState extends State<CreateBeneficiaryPage> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();
  final _formKey = GlobalKey<FormState>();
  bool? isVerified = false; // Default value for new entries

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Beneficiary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nickname is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone Number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Is Verified:'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('True'),
                      value: true,
                      groupValue: isVerified,
                      onChanged: (bool? value) {
                        setState(() {
                          isVerified = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('False'),
                      value: false,
                      groupValue: isVerified,
                      onChanged: (bool? value) {
                        setState(() {
                          isVerified = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String nickname = nicknameController.text;
                    String phoneNumber = phoneNumberController.text;
                    Beneficiary newBeneficiary = Beneficiary(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nickname: nickname,
                      phoneNumber: phoneNumber,
                      isVerified: isVerified!,
                    );
                    List<Beneficiary> beneficiaries =
                        await _sharedPrefs.getBeneficiaries();
                    beneficiaries.add(newBeneficiary);
                    await _sharedPrefs.saveBeneficiaries(beneficiaries);

                    widget.onCreated?.call();

                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
