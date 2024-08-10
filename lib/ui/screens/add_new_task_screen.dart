import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assignment8/ui/widgets/background_widget.dart';
import 'package:assignment8/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment8/ui/widgets/profile_appbar.dart';
import 'package:assignment8/ui/widgets/show_snack_bar_message.dart';

import '../controller/add_new_task_controller.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(context),
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<AddNewTaskController>(
                    init: Get.find<AddNewTaskController>(),
                    builder: (addNewTaskController  ) {
                      return Visibility(
                        visible: addNewTaskController.addNewTaskInProgress == false,
                        replacement: const CenteredProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _addNewTask,
                          child: const Text('Add'),
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
      if (_formKey.currentState!.validate()) {
        final AddNewTaskController addNewTaskController = Get.find<AddNewTaskController>();
        final bool result = await addNewTaskController.addNewTask(
          _titleTEController.text.trim(),
          _descriptionTEController.text.trim(),
        );
        if (result) {
          _clearTextFields();
          if (mounted) {
            showSnackBarMessage(context, 'New task added!');
          }
        } else {
          if (mounted) {
            showSnackBarMessage(context, 'New task add failed! Try again.', true);
          }
        }
      }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
