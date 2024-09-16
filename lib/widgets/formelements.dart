import 'package:flutter/material.dart';
import 'package:get/get.dart';



class DynamicTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  DynamicTextField({
    required this.label,
    this.initialValue,
    this.keyboardType,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}

class DynamicTextArea extends StatelessWidget {
  final String label;
  final int maxLine;
  final String? initialValue;
  final keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  DynamicTextArea({
    required this.label,
    this.maxLine = 3,
    this.initialValue,
    this.keyboardType,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLine,
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}

class DynamicFieldWrapper extends StatelessWidget {
  final List<Widget> fields;
  final int fieldCount;
  final bool isHorizontal; // if true, fields will be side by side (Row), else vertical (Column)

  DynamicFieldWrapper({
    required this.fields,
    this.fieldCount = 1,
    this.isHorizontal = false, // Default is vertical alignment
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      // If horizontal, wrap in Row and use Expanded for equal spacing
     return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          fields.length * 2 - 1,
          (index) {
            // Add SizedBox between Expanded fields
            if (index % 2 == 1) {
              return SizedBox(width: 12); // SizedBox with width 12 between Expanded widgets
            }
            return Expanded(child: fields[index ~/ 2]);
          },
        ),
      );
    } else {
      // Vertical alignment (Column)
      return Column(
        children: fields,
      );
    }
  }
}

class DynamicRadioButton extends StatelessWidget {
  final String label;
  final String? groupValue;
  final List<String> options;
  final FormFieldSetter<String>? onSaved;
  final bool isHorizontal;

  DynamicRadioButton({
    required this.label,
    required this.options,
    this.groupValue,
    this.onSaved,
    this.isHorizontal = false,
  });

 @override
 Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Wrap(
          spacing: 12, // Space between radio buttons horizontally
          runSpacing: 12, // Space between lines vertically
          children: List.generate(options.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min, // Allow Row to shrink to fit its content
              children: [
                Radio<String>(
                  value: options[index],
                  groupValue: groupValue,
                  onChanged: (String? value) {
                    if (onSaved != null) {
                      onSaved!(value!);
                    }
                  },
                ),
                Flexible(
                  child: Text(
                    options[index],
                    softWrap: true, // Ensure long text wraps to the next line
                    overflow: TextOverflow.visible, // Make sure the text doesn't overflow
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class DynamicCheckboxGroup extends StatefulWidget {
  final String label;
  final List<Map<dynamic, dynamic>> options;
  final FormFieldSetter<Map<dynamic, dynamic>>? onSaved;
  final bool isHorizontal;

  DynamicCheckboxGroup({
    required this.label,
    required this.options,
    this.onSaved,
    this.isHorizontal = false,
  });

  @override
  _DynamicCheckboxGroupState createState() => _DynamicCheckboxGroupState();
}

class _DynamicCheckboxGroupState extends State<DynamicCheckboxGroup> {
  // Handle checkbox change
  void _onCheckboxChanged(int index, bool? value) {
    setState(() {
      widget.options[index]['value'] = value; // Update the checkbox value
    });

    if (widget.onSaved != null) {
      widget.onSaved!(widget.options[index]); // Pass the updated value to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        Wrap(
          spacing: 12, // Space between checkboxes horizontally
          runSpacing: 12, // Space between lines vertically
          children: List.generate(widget.options.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min, // Allow the Row to shrink to fit its content
              children: [
                Checkbox(
                  value: widget.options[index]['value'],
                  onChanged: (bool? value) {
                    _onCheckboxChanged(index, value); // Update the state on checkbox change
                  },
                ),
                Flexible(
                  child: Text(
                    "${widget.options[index]['label']}",
                    softWrap: true, // Ensure long text wraps to the next line
                    overflow: TextOverflow.visible, // Make sure the text doesn't overflow
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}




class DynamicSwitch extends StatelessWidget {
  final String label;
  final bool initialValue;
  final FormFieldSetter<bool>? onSaved;

  DynamicSwitch({
    required this.label,
    this.initialValue = false,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: initialValue,
          onChanged: (bool value) {
            if (onSaved != null) {
              onSaved!(value);
            }
          },
        ),
      ],
    );
  }
}


class DynamicDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? initialValue;
  final FormFieldSetter<String>? onSaved;

  DynamicDropdown({
    required this.label,
    required this.options,
    this.initialValue,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(border: OutlineInputBorder() ,labelText: label),
      value: initialValue,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? value) {
        if (onSaved != null) {
          onSaved!(value!);
        }
      },
    );
  }
}
