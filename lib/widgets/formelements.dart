import 'package:flutter/material.dart';
import 'package:get/get.dart';



class DynamicTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool isRequired;
  final keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  DynamicTextField({
    required this.label,
    this.initialValue,
    this.isRequired = false,
    this.keyboardType,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
          text: label, // The main label text
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: isRequired == true?[
            TextSpan(
              text: ' *', // The asterisk
              style: TextStyle(color: Colors.red, fontSize: 16), // Red color for asterisk
            ),
          ]:[],
        ),
        ),
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
  final bool isRequired;
  final keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  DynamicTextArea({
    required this.label,
    this.maxLine = 3,
    this.initialValue,
    this.isRequired = false,
    this.keyboardType,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
       label: RichText(
          text: TextSpan(
          text: label, // The main label text
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: isRequired == true?[
            TextSpan(
              text: ' *', // The asterisk
              style: TextStyle(color: Colors.red, fontSize: 16), // Red color for asterisk
            ),
          ]:[],
        ),
        ),
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
  final bool isRequired;

  DynamicRadioButton({
    required this.label,
    required this.options,
    this.isRequired = false,
    this.groupValue,
    this.onSaved,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ensure the RichText is aligned at the start of the screen
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: label, // The main label text
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(color: Colors.red, fontSize: 16), // Red color for asterisk
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        isHorizontal
            ? Wrap(
                spacing: 12, // Space between radio buttons horizontally
                runSpacing: 12, // Space between lines vertically
                direction: Axis.horizontal, // Horizontal layout
                children: List.generate(options.length, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
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
                      Text(
                        options[index],
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  );
                }),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align vertically
                children: List.generate(options.length, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
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
                      Text(
                        options[index],
                        softWrap: true,
                        overflow: TextOverflow.visible,
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
  final bool isRequired;

  DynamicCheckboxGroup({
    required this.label,
    required this.options,
    this.onSaved,
    this.isHorizontal = false,
    this.isRequired = false,
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
         Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: widget.label, // The main label text
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: widget.isRequired
                  ? [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(color: Colors.red, fontSize: 16), // Red color for asterisk
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        widget.isHorizontal
            ? Wrap(
          spacing: 12.0, // Space between checkboxes horizontally
          runSpacing: 12.0, // Space between rows of checkboxes vertically
          direction: widget.isHorizontal ? Axis.horizontal : Axis.vertical, // Control wrap direction
          children: List.generate(widget.options.length, (index) {
            return Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9), // Restrict width
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            );
          }),
        )
            : Column(
                children: List.generate(widget.options.length, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
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
                          softWrap: true,
                          overflow: TextOverflow.visible,
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
  final bool isRequired;
  final FormFieldSetter<bool>? onSaved;

  DynamicSwitch({
    required this.label,
    this.initialValue = false,
    this.isRequired = false,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         RichText(
          text: TextSpan(
          text: label, // The main label text
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: isRequired == true?[
            TextSpan(
              text: ' *', // The asterisk
              style: TextStyle(color: Colors.red, fontSize: 16), // Red color for asterisk
            ),
          ]:[],
        ),
        ),
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
  final bool isRequired;
  final FormFieldSetter<String>? onSaved;

  DynamicDropdown({
    required this.label,
    required this.options,
    this.initialValue,
    this.isRequired = false,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(border: OutlineInputBorder() ,label:  RichText(
          text: TextSpan(
          text: label, // The main label text
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: isRequired == true?[
            TextSpan(
              text: ' *', // The asterisk
              style: TextStyle(color: Colors.red, fontSize: 16), // Red color for asterisk
            ),
          ]:[],
        ),
        ),),
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
