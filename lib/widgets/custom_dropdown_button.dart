import 'package:flutter/material.dart';
import 'package:trashtrack_user/models/option/option.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.value,
    this.hint,
    required this.options,
    this.onChanged,
    this.labelText,
  });

  final String value;
  final String? hint;
  final List<Option> options;
  final void Function(String?)? onChanged;
  final String? labelText; // Label text

  OutlineInputBorder borderStyle(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the dropdown
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              labelText!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF02413C), // Label color
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color for the dropdown
            borderRadius: BorderRadius.circular(12), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow offset
              ),
            ],
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: hint != null
                ? Center(
                    child:
                        Text(hint!, style: const TextStyle(color: Colors.grey)),
                  )
                : null,
            items: options.map((Option option) {
              return DropdownMenuItem<String>(
                value: option.id,
                child: Center(child: Text(option.label)), // Center the text
              );
            }).toList(),
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black, // Text color for dropdown items
            ),
            dropdownColor: Colors.white, // Dropdown background color
            underline: const SizedBox(), // Remove the default underline
            iconEnabledColor: const Color(0xFF02413C), // Icon color
            icon: const Icon(Icons.arrow_drop_down), // Custom dropdown icon
          ),
        ),
        // Optional: Add some spacing below the dropdown
        const SizedBox(height: 8),
      ],
    );
  }
}
