// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sign_in_button/sign_in_button.dart';
// import 'package:trashtrack_user/blocs/auth/login/login_bloc.dart';
// import 'package:trashtrack_user/helpers/message_dialog_helper.dart';
// import 'terms_page.dart'; // Import the modal

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   final bool _isTermsAccepted = false;

//   void _signinAuthAccount(BuildContext context) {
//     if (_isTermsAccepted) {
//       BlocProvider.of<LoginBloc>(context).add(LoginAccountEvent());
//     } else {
//       // Show the terms and conditions modal
//       TermsPageModal.showTermsModal(
//         context,
//         () {
//           // When terms are accepted
//           Navigator.pop(context); // Close the modal
//           BlocProvider.of<LoginBloc>(context).add(LoginAccountEvent());
//         },
//         () {
//           // When terms are denied
//           Navigator.pop(context); // Close the modal
//           // You can delete the account or perform other actions here
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const double fixedBackgroundHeight = 450.0;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: fixedBackgroundHeight,
//             child: CustomPaint(
//               painter: BackgroundPainter(),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   const SizedBox(height: 80),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Center(
//                       child: Image.asset(
//                         'lib/assets/images/logo-trashtrack.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'TrashTrack',
//                     style: TextStyle(
//                       fontSize: 40,
//                       fontWeight: FontWeight.bold,
//                       foreground: Paint()
//                         ..shader = const LinearGradient(
//                           colors: [Color(0xFF84CF0F), Color(0xFF00993D)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
//                       fontFamily: 'Lalezar',
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Please sign in to continue',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 40),
//                   buildLoginBC(context),
//                   const SizedBox(height: 25),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   BlocConsumer buildLoginBC(BuildContext context) {
//     return BlocConsumer<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is LoginErrorState) {
//           MessageDialogHelper.showErrorDialog(
//             context,
//             'Login Error',
//             state.message,
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state is LoginProcessingState) {
//           return const CircularProgressIndicator();
//         } else {
//           return buildLoginButton(context);
//         }
//       },
//     );
//   }

//   SignInButton buildLoginButton(BuildContext context) {
//     return SignInButton(
//       onPressed: () => _signinAuthAccount(context),
//       text: "Login and Register",
//       Buttons.google,
//     );
//   }
// }

// class BackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFF02413C)
//       ..style = PaintingStyle.fill;

//     final path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(0, size.height * 0.7)
//       ..quadraticBezierTo(
//           size.width / 2, size.height * 0.8, size.width, size.height * 0.7)
//       ..lineTo(size.width, 0)
//       ..close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashtrack_user/blocs/auth/login/login_bloc.dart';
import 'package:trashtrack_user/helpers/message_dialog_helper.dart';
import 'package:trashtrack_user/models/credential/credential.dart';
import 'package:trashtrack_user/pages/forgot_page.dart';
import 'package:trashtrack_user/pages/register_page.dart';
import 'package:trashtrack_user/validators/email_validator.dart';
import 'package:trashtrack_user/validators/password_validator.dart';
import 'package:trashtrack_user/widgets/custom_app_bar.dart';
import 'package:trashtrack_user/widgets/custom_elevated_button.dart';
import 'package:trashtrack_user/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  IconData _visibilityIcon = Icons.visibility_off;
  bool _passwordHidden = true;

  void _showHidePassword() {
    setState(() {
      _passwordHidden = !_passwordHidden;

      if (_passwordHidden) {
        _visibilityIcon = Icons.visibility_off;
      } else {
        _visibilityIcon = Icons.visibility;
      }
    });
  }

  void _signinAuthAccount() {
    FormState? formState = _formKey.currentState;

    if (formState != null) {
      if (formState.validate()) {
        BlocProvider.of<LoginBloc>(context).add(
          LoginAccountEvent(
            Credential(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          ),
        );
      }
    }
  }

  void _gotoRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const RegisterPage(),
      ),
    );
  }

  void _gotoForgotPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ForgotPage(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double fixedBackgroundHeight = 450.0;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: fixedBackgroundHeight,
            child: CustomPaint(
              painter: BackgroundPainter(),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 80),
                    Container(
                      width: double.infinity,
                      child: Center(
                        child: Image.asset(
                          'lib/assets/images/logo-trashtrack.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'TrashTrack',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Color(0xFF84CF0F), Color(0xFF00993D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                        fontFamily: 'Lalezar',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Please sign in to continue',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      textController: _emailController,
                      prefixIcon: Icons.email,
                      labelText: 'Email',
                      onPressed: () => _emailController.clear(),
                      suffixIcon: Icons.clear,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      textController: _passwordController,
                      prefixIcon: Icons.lock,
                      labelText: 'Password',
                      onPressed: _showHidePassword,
                      suffixIcon: _visibilityIcon,
                      obscureText: _passwordHidden,
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _gotoForgotPage,
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    buildLoginBC(), // Sign in button
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                            indent: 20,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          'or',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                            indent: 10,
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: _gotoRegisterPage,
                      isExpanded: true,
                      labelText: 'Register',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BlocConsumer buildLoginBC() {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          MessageDialogHelper.showErrorDialog(
            context,
            'Login Error',
            state.message,
          );
        }
      },
      builder: (context, state) {
        if (state is LoginProcessingState) {
          return const CircularProgressIndicator();
        } else {
          return buildLoginButton();
        }
      },
    );
  }

  CustomElevatedButton buildLoginButton() {
    return CustomElevatedButton(
      onPressed: _signinAuthAccount,
      isExpanded: true,
      labelText: 'Signin',
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF02413C)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
          size.width / 2, size.height * 0.8, size.width, size.height * 0.7)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
