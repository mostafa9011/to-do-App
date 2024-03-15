import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app/tasks/models/task_model.dart';
import 'package:todo_app/config/constants/constants.dart';
import 'package:todo_app/config/constants/extract_time.dart';
import 'package:todo_app/config/cubits/settings_cubit/settings_cubit.dart';
import 'package:todo_app/config/services/firebase_utils.dart';
import 'package:todo_app/config/widgets/custom_text_field.dart';

import '../../../config/services/snake_bar_services.dart';

class ModalSheet extends StatefulWidget {
  const ModalSheet({super.key, required this.title, required this.buttonName});
  final String title;
  final String buttonName;

  @override
  State<ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  String? title, content;
  DateTime time = DateTime.now();
  CollectionReference tasks = FirebaseFirestore.instance.collection('Tasks');
  GlobalKey<FormState> formKey = GlobalKey();
  //DateTime selectedDate = DateTime.now();
  var firestoreManage = FirestoreManager();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    var vm = BlocProvider.of<CubitSettings>(context);
    return Container(
      padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 40,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.title,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: vm.isLight() ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextFormField(
                onChanged: (value) {
                  title = value;
                },
                onValidate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Feild Required !';
                  } else {
                    return null;
                  }
                },
                hint: 'Enter your task.',
                hintColor: Colors.grey,
              ),
              CustomTextFormField(
                onChanged: (value) {
                  content = value;
                },
                onValidate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Feild Required !';
                  } else {
                    return null;
                  }
                },
                hint: 'Enter content',
                hintColor: Colors.grey,
                maxLines: 3,
                maxLength: 150,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Select Time',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: vm.isLight() ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () async {
                  var currentSelectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                    currentDate: DateTime.now(),
                    initialDate: vm.selectedDate,
                  );
                  if (currentSelectedDate == null) return;
                  setState(() {
                    vm.selectedDate = currentSelectedDate;
                  });
                },
                child: Text(
                  DateFormat.yMMMd().format(vm.selectedDate),
                  style:
                      theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    fixedSize: Size(mediaQuery.size.width * 0.8, 20),
                  ),
                  onPressed: () async {
                    TaskModel task = TaskModel(
                      title: title!,
                      content: content!,
                      time: extractTime(vm.selectedDate),
                      isDone: false,
                    );
                    EasyLoading.show();
                    firestoreManage.addTask(task).then(
                      (value) {
                        EasyLoading.dismiss();
                        Navigator.pop(context);
                        SnackBarService.showSuccessMessage(
                          'Added Succsessful',
                          // color: theme.scaffoldBackgroundColor,
                        );
                      },
                    );
                  },
                  child: Text(
                    widget.buttonName, // Add
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
