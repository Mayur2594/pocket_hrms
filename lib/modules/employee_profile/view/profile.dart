import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocket_hrms/modules/employee_profile/controller/profile.dart';
import 'package:pocket_hrms/widgets/appbar.dart';
import 'package:pocket_hrms/widgets/appdrawer.dart';
import 'package:pocket_hrms/widgets/bottombar.dart';
import 'package:pocket_hrms/widgets/formelements.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final ProfileController ProfileCtrl = Get.find();
    return Scaffold(
      appBar: AppBarView(appBarTitle: "Profile"),
      drawer: DrawerView(),
      body: RefreshIndicator(
         onRefresh: () => ProfileCtrl.refreshView(),
          child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
         key: ProfileCtrl.profileFormKey,
          child: Obx(() => Column(
            children: [
             
              DynamicFieldWrapper(
                fields: [
                  DynamicTextField(
                    label: 'First Name',
                    initialValue: '',
                    isRequired:true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your First name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      ProfileCtrl.formData['first_name'] = value;
                    },
                  ),
                   DynamicTextField(
                    label: 'Middel Name',
                    initialValue: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Middle name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      ProfileCtrl.formData['mid_name'] = value;
                    },
                  ),
                  DynamicTextField(
                    label: 'Last Name',
                    initialValue: '',
                    isRequired:true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      ProfileCtrl.formData['last_name'] = value;
                    },
                  ),
                ],
                fieldCount: 2,
                isHorizontal: true,
              ),
              SizedBox(height: 16),

              // Two Radio Buttons side by side
              
            DynamicRadioButton(
                    label: 'Gender',
                    isRequired:true,
                    options: ['Male', 'Female', 'Other', 'Not to desclosed'],
                    groupValue: ProfileCtrl.formData['gender'],
                    onSaved: (value) {
                      ProfileCtrl.formData['gender'] = value;
                    },
                    isHorizontal: true, 
                  ),

              SizedBox(height: 16,),
              DynamicDropdown(
                    label: 'Payment Method',
                    isRequired:true,
                    options: ['Credit Card', 'PayPal'],
                    initialValue: ProfileCtrl.formData['payment_method'],
                    onSaved: (value) {
                      ProfileCtrl.formData['payment_method'] = value;
                    },
                  ),
                
              SizedBox(height: 16),

               DynamicFieldWrapper(
                fields: [
                  DynamicSwitch(
                    label:"Active Location",
                    isRequired:true,
                    initialValue: ProfileCtrl.formData['active_location']??false,
                    onSaved: (value) {
                      ProfileCtrl.formData['active_location'] = value;
                    },
                  ),
                ]
               ),
              SizedBox(height: 16),

              // Checkbox vertically aligned
              DynamicCheckboxGroup(
              label: 'Hobbies',
              options: ProfileCtrl.options,
              isRequired:true,
              onSaved: (value) {
                  ProfileCtrl.formData['hobbies'] = ProfileCtrl.options;
              },
              isHorizontal: true, // Horizontal layout with wrapping after two items
            ),
              SizedBox(height: 16),
              DynamicTextArea(
                    label: 'Address',
                    isRequired: true,
                    initialValue: ProfileCtrl.formData['address']??null,
                    maxLine: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      ProfileCtrl.formData['address'] = value;
                    },
                  ),
                   
              SizedBox(height: 16),
              // Submit button
              ElevatedButton(
                onPressed: () {

                  if (ProfileCtrl.profileFormKey.currentState!.validate()) {
                      ProfileCtrl.profileFormKey.currentState!.save(); // Trigger onSaved for all fields
                      print('Form Data: ${ProfileCtrl.formData}'); // Check the saved data
                    }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
        ),
      )          )
          
      ),
       bottomNavigationBar: BottomBarView(tabName: 'dashboard'),
    );
  }

  


}