import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_up_beneficiary_app/app/features/beneficiaries/domain/entities/beneficiary.dart';
import 'package:top_up_beneficiary_app/core/shared_preferences_services.dart';

class EditBeneficiaryPage extends StatefulWidget {
  const EditBeneficiaryPage(
      {super.key, required this.beneficiary, this.onEdit});

  final Beneficiary beneficiary;
  final Function()? onEdit;

  @override
  EditBeneficiaryPageState createState() => EditBeneficiaryPageState();
}

class EditBeneficiaryPageState extends State<EditBeneficiaryPage> {
  late TextEditingController nicknameController;
  late TextEditingController phoneNumberController;
  final SharedPreferencesService _sharedPrefs = SharedPreferencesService();
  final _formKey = GlobalKey<FormState>();
  bool? isVerified;

  @override
  void initState() {
    super.initState();
    nicknameController =
        TextEditingController(text: widget.beneficiary.nickname);
    phoneNumberController =
        TextEditingController(text: widget.beneficiary.phoneNumber);
    isVerified = widget.beneficiary.isVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Beneficiary'),
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
                    Beneficiary updatedBeneficiary = Beneficiary(
                      id: widget.beneficiary.id,
                      nickname: nickname,
                      phoneNumber: phoneNumber,
                      isVerified: isVerified!,
                    );
                    List<Beneficiary> beneficiaries =
                        await _sharedPrefs.getBeneficiaries();
                    int index = beneficiaries
                        .indexWhere((b) => b.id == updatedBeneficiary.id);
                    beneficiaries[index] = updatedBeneficiary;
                    await _sharedPrefs.saveBeneficiaries(beneficiaries);

                    widget.onEdit?.call();
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
