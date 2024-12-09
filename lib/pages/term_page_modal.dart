import 'package:flutter/material.dart';
import 'package:trashtrack_user/widgets/custom_elevated_button.dart';

class TermsPageModal {
  static void showTermsModal(BuildContext context, VoidCallback onTermsAccepted,
      VoidCallback onTermsDenied) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to our app! These terms and conditions outline the rules and regulations for the use of our app.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '1. Acceptance of Terms',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'By accessing this app, you accept these terms and conditions in full. Do not continue to use the app if you do not accept all of the terms and conditions stated in this document.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '2. Geographic Restrictions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'This application is primarily designed and optimized for use within Mandaluyong City. While the application may be technically accessible outside Mandaluyong City, we do not guarantee its functionality, accuracy, or reliability outside the designated service area. Users acknowledge that full service features are only guaranteed within Mandaluyong City limits, and access to services, features, and data may be limited or unavailable outside this area. The company bears no responsibility for any service limitations experienced outside Mandaluyong City.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '3. User Responsibilities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You also consent to location verification as a condition of using the service.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '4. Limitation of Liability',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'In no event shall the app or its owners be liable for any damages arising from the use of this app. We make no warranties or representations regarding the Application\'s performance outside Mandaluyong City.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '5. Changes to Terms',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'We may update these terms from time to time. We will notify you of any changes by posting the new terms on this page.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '6. Contact Us',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'If you have any questions about these terms, please contact us at Esprajn@students.national-u.edu.ph or Gayaniloxm@students.national-u.edu.ph.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        onTermsAccepted();
                      },
                      labelText: 'Accept Terms',
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        onTermsDenied();
                      },
                      backgroundColor: Colors.red,
                      labelText: 'Deny Terms',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
