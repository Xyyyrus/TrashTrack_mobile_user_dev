import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashtrack_user/blocs/auth/register/register_bloc.dart';
import 'package:trashtrack_user/blocs/route/get_routes/get_routes_bloc.dart';
import 'package:trashtrack_user/helpers/message_dialog_helper.dart';
import 'package:trashtrack_user/models/credential/credential.dart';
import 'package:trashtrack_user/models/option/option.dart';
import 'package:trashtrack_user/pages/terms_page.dart';
import 'package:trashtrack_user/validators/email_validator.dart';
import 'package:trashtrack_user/validators/firstname_validator.dart';
import 'package:trashtrack_user/validators/lastname_validator.dart';
import 'package:trashtrack_user/validators/password_validator.dart';
import 'package:trashtrack_user/widgets/custom_app_bar.dart';
import 'package:trashtrack_user/widgets/custom_dropdown_button.dart';
import 'package:trashtrack_user/widgets/custom_elevated_button.dart';
import 'package:trashtrack_user/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedBarangay = '';
  IconData _visibilityIcon = Icons.visibility_off;
  bool _passwordHidden = true;
  final List<Option> _routeList = [];
  bool _isChecked = false;

  void _getRoutesList() {
<<<<<<< HEAD
    BlocProvider.of<GetRoutesBloc>(context).add(GetRoutesEvent());
=======
    BlocProvider.of<GetRoutesBloc>(context).add(
      GetRoutesEvent(),
    );
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
  }

  void _changeSelectedBarangay(String? value) {
    setState(() {
      _selectedBarangay = value!;
    });
  }

  void _showHidePassword() {
    setState(() {
      _passwordHidden = !_passwordHidden;
<<<<<<< HEAD
      _visibilityIcon =
          _passwordHidden ? Icons.visibility_off : Icons.visibility;
=======

      if (_passwordHidden) {
        _visibilityIcon = Icons.visibility_off;
      } else {
        _visibilityIcon = Icons.visibility;
      }
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
    });
  }

  void _toggleTermsConditions(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void _gotoTermsPage() async {
    final bool? agreed = await Navigator.push(
      context,
<<<<<<< HEAD
      MaterialPageRoute(builder: (BuildContext context) => const TermsPage()),
=======
      MaterialPageRoute(
        builder: (BuildContext context) => const TermsPage(),
      ),
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
    );

    if (agreed == true) {
      setState(() {
        _isChecked = true;
      });
    }
  }

  void _signupAuthAccount() {
    FormState? formState = _formKey.currentState;

<<<<<<< HEAD
    if (formState != null && formState.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(
        RegisterAccountEvent(
          Credential(
            firstname: _firstnameController.text.trim(),
            lastname: _lastnameController.text.trim(),
            barangay: _selectedBarangay,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        ),
      );
=======
    if (formState != null) {
      if (formState.validate()) {
        BlocProvider.of<RegisterBloc>(context).add(
          RegisterAccountEvent(
            Credential(
              firstname: _firstnameController.text.trim(),
              lastname: _lastnameController.text.trim(),
              barangay: _selectedBarangay,
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          ),
        );
      }
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
<<<<<<< HEAD
=======

>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
    super.dispose();
  }

  @override
  void initState() {
    _getRoutesList();
<<<<<<< HEAD
=======

>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Register'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CustomTextField(
                  textController: _firstnameController,
                  prefixIcon: Icons.person,
                  labelText: 'Firstname',
                  onPressed: () => _firstnameController.clear(),
                  suffixIcon: Icons.clear,
                  validator: firstnameValidator,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  textController: _lastnameController,
                  prefixIcon: Icons.person,
                  labelText: 'Lastname',
                  onPressed: () => _lastnameController.clear(),
                  suffixIcon: Icons.clear,
                  validator: lastnameValidator,
                ),
                const SizedBox(height: 15),
                buildGetRoutesBC(),
                const SizedBox(height: 15),
                CustomTextField(
                  textController: _emailController,
                  prefixIcon: Icons.email,
                  labelText: 'Email',
                  onPressed: () => _emailController.clear(),
                  suffixIcon: Icons.clear,
                  validator: emailValidator,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  textController: _passwordController,
                  prefixIcon: Icons.lock,
                  labelText: 'Password',
<<<<<<< HEAD
                  onPressed: _showHidePassword,
=======
                  onPressed: () => _showHidePassword(),
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
                  suffixIcon: _visibilityIcon,
                  obscureText: _passwordHidden,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 15),
                buildTCRow(),
                const SizedBox(height: 25),
                buildRegisterBC(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTCRow() {
    return Row(
      children: <Widget>[
        Checkbox(
          value: _isChecked,
          onChanged: (bool? newValue) async {
            if (newValue == true) {
<<<<<<< HEAD
              _gotoTermsPage();
            } else {
=======
              // If trying to check, go to the terms page and let them agree
              _gotoTermsPage();
            } else {
              // Allow unchecking the box directly
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
              setState(() {
                _isChecked = false;
              });
            }
          },
        ),
        GestureDetector(
          onTap: _gotoTermsPage,
          child: const Text(
            'Agree to our Terms and Conditions',
            style: TextStyle(fontSize: 17, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  BlocConsumer buildGetRoutesBC() {
    return BlocConsumer<GetRoutesBloc, GetRoutesState>(
      listener: (context, state) {
        if (state is GetRoutesSuccessfulState) {
          final allRoutes = state.routes;

          for (final route in allRoutes) {
            _routeList.add(Option(
              id: route.id,
              label: route.name,
            ));
          }

          _selectedBarangay = _routeList.first.id;
        }
      },
      builder: (context, state) {
        if (state is GetRoutesSuccessfulState) {
          return CustomDropdownButton(
            value: _selectedBarangay,
            options: _routeList,
<<<<<<< HEAD
            onChanged: _changeSelectedBarangay,
=======
            onChanged: (value) => _changeSelectedBarangay(value),
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
          );
        } else if (state is GetRoutesErrorState) {
          return Text(
            state.message,
            style: const TextStyle(fontSize: 17),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  BlocConsumer buildRegisterBC() {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessfulState) {
          Navigator.pop(context);
<<<<<<< HEAD
        } else if (state is RegisterErrorState) {
=======
        }

        if (state is RegisterErrorState) {
>>>>>>> 1e77c47997af77dab89e0427b2db0e4d0829c202
          MessageDialogHelper.showErrorDialog(
            context,
            'Register Error',
            state.message,
          );
        }
      },
      builder: (context, state) {
        if (state is RegisterProcessingState) {
          return const CircularProgressIndicator();
        } else {
          return buildGetRoutesBB();
        }
      },
    );
  }

  BlocBuilder buildGetRoutesBB() {
    return BlocBuilder<GetRoutesBloc, GetRoutesState>(
      builder: (context, state) {
        void Function() onPressed = () {};
        Color backGroundColor = Colors.grey;

        if (_isChecked && state is GetRoutesSuccessfulState) {
          onPressed = _signupAuthAccount;
          backGroundColor = Colors.green;
        }

        return CustomElevatedButton(
          onPressed: onPressed,
          isExpanded: true,
          backgroundColor: backGroundColor,
          labelText: 'Register',
        );
      },
    );
  }
}
