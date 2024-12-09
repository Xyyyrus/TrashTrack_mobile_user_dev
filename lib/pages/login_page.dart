import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:trashtrack_user/blocs/auth/login/login_bloc.dart';
import 'package:trashtrack_user/helpers/message_dialog_helper.dart';
import 'package:trashtrack_user/models/credential/credential.dart';
import 'package:trashtrack_user/pages/forgot_page.dart';
import 'package:trashtrack_user/pages/register_page.dart';
import 'package:trashtrack_user/validators/email_validator.dart';
import 'package:trashtrack_user/validators/password_validator.dart';
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
      _visibilityIcon =
          _passwordHidden ? Icons.visibility_off : Icons.visibility;
    });
  }

  void _signinAuthAccount() {
    FormState? formState = _formKey.currentState;

    if (formState != null && formState.validate()) {
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

  void _signinWithGoogle() {
    BlocProvider.of<LoginBloc>(context).add(LoginGoogleEvent());
  }

  void _gotoRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _gotoForgotPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPage()),
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
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures that the screen resizes when the keyboard appears
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background painter
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundPainter(),
                ),
              ),
              // Main content
              Column(
                children: [
                  const SizedBox(height: 20), // Add some spacing at the top
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo
                          Image.asset(
                            'lib/assets/images/logo-trashtrack.png',
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          // App title
                          Text(
                            'TrashTrack',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF84CF0F),
                                    Color(0xFF00993D)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70)),
                              fontFamily: 'Lalezar',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // Subtitle
                          Text(
                            'Please sign in to continue',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Email input
                          CustomTextField(
                            textController: _emailController,
                            prefixIcon: Icons.email,
                            labelText: 'Email',
                            onPressed: () => _emailController.clear(),
                            suffixIcon: Icons.clear,
                            validator: emailValidator,
                          ),
                          const SizedBox(height: 20),
                          // Password input
                          CustomTextField(
                            textController: _passwordController,
                            prefixIcon: Icons.lock,
                            labelText: 'Password',
                            onPressed: _showHidePassword,
                            suffixIcon: _visibilityIcon,
                            obscureText: _passwordHidden,
                            validator: passwordValidator,
                          ),
                          const SizedBox(height: 20),
                          // Google sign-in button
                          SignInButton(
                            Buttons.google,
                            text: "Sign in with Google",
                            onPressed: _signinWithGoogle,
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
                          const SizedBox(height: 20),
                          // Sign-in button
                          buildLoginBC(),
                          const SizedBox(height: 20),
                          // Or divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'or',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Register button
                          CustomElevatedButton(
                            onPressed: _gotoRegisterPage,
                            isExpanded: true,
                            labelText: 'Register',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Add bottom padding to prevent overflow
                ],
              ),
            ],
          ),
        ),
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
      labelText: 'Sign in',
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
      ..lineTo(0, size.height * 0.3) // Lower height to terminate earlier
      ..quadraticBezierTo(
          size.width / 2, size.height * 0.37, size.width, size.height * 0.3)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
