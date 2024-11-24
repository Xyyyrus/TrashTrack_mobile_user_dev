import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashtrack_user/blocs/profile/get_profile/get_profile_bloc.dart';
import 'package:trashtrack_user/blocs/profile/update_profile/update_profile_bloc.dart';
import 'package:trashtrack_user/helpers/message_dialog_helper.dart';
import 'package:trashtrack_user/models/option/option.dart';
import 'package:trashtrack_user/models/profile/profile.dart';
import 'package:trashtrack_user/pages/protected/profile/map_page.dart';
import 'package:trashtrack_user/validators/firstname_validator.dart';
import 'package:trashtrack_user/validators/lastname_validator.dart';

import 'package:trashtrack_user/widgets/custom_dropdown_button.dart';
import 'package:trashtrack_user/widgets/custom_elevated_button.dart';
import 'package:trashtrack_user/widgets/custom_text_field.dart';
import 'package:trashtrack_user/models/route/route.dart' as rm;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.profile,
    required this.routes,
  });

  final Profile profile;
  final List<rm.Route> routes;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final List<Option> _routeList = [];
  String _selectedBarangay = '';

  void _generateRouteList() {
    for (final route in widget.routes) {
      _routeList.add(Option(
        id: route.id,
        label: route.name,
      ));
    }
  }

  void _getProfileDetails() {
    BlocProvider.of<GetProfileBloc>(context).add(
      GetProfileEvent(_selectedBarangay),
    );
  }

  void _changeSelectedBarangay(String? value) {
    setState(() {
      _selectedBarangay = value!;
    });
  }

  // void _updateProfile() {
  //   FormState? formState = _formKey.currentState;

  //   if (formState != null) {
  //     if (formState.validate()) {
  //       BlocProvider.of<UpdateProfileBloc>(context).add(
  //         UpdateProfileEvent(
  //           widget.profile.copyWith(
  //             firstname: _firstnameController.text.trim(),
  //             lastname: _lastnameController.text.trim(),
  //             barangay: _selectedBarangay,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }
  void _updateProfile() {
    String firstname = _firstnameController.text.trim();
    String lastname = _lastnameController.text.trim();
    FormState? formState = _formKey.currentState;

    if (firstname.isEmpty ||
        firstname.toLowerCase() == 'firstname' ||
        lastname.isEmpty ||
        lastname.toLowerCase() == 'lastname') {
      MessageDialogHelper.showErrorDialog(
        context,
        'Invalid Username',
        "Please change your username.",
      );
    } else {
      // Trigger the UpdateProfile event
      BlocProvider.of<UpdateProfileBloc>(context).add(
        UpdateProfileEvent(widget.profile.copyWith(
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
          barangay: _selectedBarangay,
        )),
      );
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();

    super.dispose();
  }

  // @override
  // void initState() {
  //   _firstnameController.text = widget.profile.firstname ?? '';
  //   _lastnameController.text = widget.profile.lastname ?? '';
  //   _selectedBarangay = widget.profile.barangay ?? '';
  //   _generateRouteList();

  //   super.initState();
  // }

  @override
  void initState() {
    // Initialize the controllers with profile values, or empty them if they are default values
    String firstname = widget.profile.firstname ?? '';
    String lastname = widget.profile.lastname ?? '';

    // Check if firstname and lastname have the default values
    if (firstname.toLowerCase() == 'firstname' &&
        lastname.toLowerCase() == 'lastname') {
      firstname = ''; // Set to empty if it's the default value
      lastname = ''; // Set to empty if it's the default value
    }

    // Assign values to the controllers
    _firstnameController.text = firstname;
    _lastnameController.text = lastname;

    // Initialize the barangay and route list
    _selectedBarangay = widget.profile.barangay ?? '';
    _generateRouteList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _validateAndNavigate(context);
          },
        ),
      ),
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
                  labelText: 'First name',
                  onPressed: () => _firstnameController.clear(),
                  suffixIcon: Icons.clear,
                  validator: firstnameValidator,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  textController: _lastnameController,
                  prefixIcon: Icons.person,
                  labelText: 'Last name',
                  onPressed: () => _lastnameController.clear(),
                  suffixIcon: Icons.clear,
                  validator: lastnameValidator,
                ),
                const SizedBox(height: 15),
                CustomDropdownButton(
                  value: _selectedBarangay,
                  hint: 'Select an option',
                  options: _routeList,
                  onChanged: (value) => _changeSelectedBarangay(value),
                  labelText: 'Routes', // Set your label here
                ),
                const SizedBox(height: 45),
                buildMapButton(),
                const SizedBox(height: 15),
                buildUPBC(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndNavigate(BuildContext context) {
    String firstname = _firstnameController.text.trim();
    String lastname = _lastnameController.text.trim();

    // Validation logic
    if (firstname.isEmpty ||
        firstname.toLowerCase() == 'firstname' ||
        lastname.isEmpty ||
        lastname.toLowerCase() == 'lastname') {
      // Show a SnackBar or AlertDialog to inform the user
      MessageDialogHelper.showErrorDialog(
        context,
        'Set Your Account first.',
        'Please enter valid first and last names.',
      );
    } else {
      // Navigate to the desired page if validation passes
      Navigator.pop(context); // This will go back to the previous page
      // Or replace it with your navigation logic if needed
      // Navigator.push(context, MaterialPageRoute(builder: (context) => YourNextPage()));
    }
  }

  BlocConsumer buildUPBC() {
    return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        String firstname = _firstnameController.text.trim();
        String lastname = _lastnameController.text.trim();
        if (firstname.isEmpty ||
            firstname.toLowerCase() == 'firstname' ||
            lastname.isEmpty ||
            lastname.toLowerCase() == 'lastname') {
          MessageDialogHelper.showErrorDialog(
            context,
            'Invalid Username',
            "Change your user name",
          );
        }
        if (state is UpdateProfileSuccessfulState) {
          MessageDialogHelper.showSuccessDialog(
            context,
            'Updating Success',
            state.message,
          );

          _getProfileDetails();
        }

        if (state is UpdateProfileErrorState) {
          MessageDialogHelper.showErrorDialog(
            context,
            'Updating Error',
            state.message,
          );
        }
      },
      builder: (context, state) {
        if (state is UpdateProfileProcessingState) {
          return const CircularProgressIndicator();
        } else {
          return buildUpdateButton();
        }
      },
    );
  }

  CustomElevatedButton buildUpdateButton() {
    return CustomElevatedButton(
      onPressed: _updateProfile,
      isExpanded: true,
      labelText: 'Update',
    );
  }

  CustomElevatedButton buildMapButton() {
    return CustomElevatedButton(
      onPressed: _navigateToMap,
      isExpanded: true,
      labelText: 'View Collection Routes',
      backgroundColor: Colors.orange,
    );
  }

  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MapPage(
                selectedBarangay: '',
              )),
    );
  }
}
