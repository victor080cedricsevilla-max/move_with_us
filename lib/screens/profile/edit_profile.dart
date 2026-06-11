import 'package:flutter/material.dart';

import '../../widgets/common.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Center(
            child: GestureDetector(
              onTap: () => showIOSSheet<String>(context, actions: const [
                (label: 'Take Photo', value: 'take', destructive: false),
                (label: 'Choose Photo', value: 'choose', destructive: false),
              ]),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFB9A79A),
                child: Icon(Icons.person, color: Colors.white, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 28),
          CreamField(label: 'First Name', controller: TextEditingController(text: 'Julia')),
          const SizedBox(height: 16),
          CreamField(label: 'Last Name', controller: TextEditingController(text: 'Screens')),
          const SizedBox(height: 16),
          CreamField(label: 'Email', controller: TextEditingController(text: 'screensdesigntest@gmail.com')),
          const SizedBox(height: 16),
          CreamField(label: 'Date of Birth', controller: TextEditingController(text: '17 June 1999'), readOnly: true),
          const SizedBox(height: 32),
          SageButton(
            label: 'SAVE CHANGES',
            onPressed: () {
              showIOSNotice(context, title: 'Saved', message: 'Your profile has been updated.', okText: 'Okay');
            },
          ),
        ],
      ),
    );
  }
}
