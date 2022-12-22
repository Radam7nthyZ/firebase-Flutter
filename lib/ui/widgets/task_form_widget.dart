import 'package:flutter/material.dart';
import 'package:firebase/models/task_model.dart';
import 'package:firebase/services/my_service_firestore.dart';
import 'package:firebase/ui/widgets/textFlied_normal_widget.dart';

import '../general/colors.dart';
import 'button_normal_widget.dart';
import 'general_widgets.dart';

class Taskformwidget extends StatefulWidget {
  const Taskformwidget({super.key});

  @override
  State<Taskformwidget> createState() => _TaskformwidgetState();
}

class _TaskformwidgetState extends State<Taskformwidget> {
  MyServiceFirestore taskService = MyServiceFirestore(collection: "tasks");

  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String categorySelected = "Personal";

  showSelectDate() async {
    DateTime? datetime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      cancelText: "Cancelar",
      confirmText: "Aceptar",
      helpText: "Seleccionar Fecha",
      builder: (BuildContext context, Widget? widget) {
        return Theme(
          data: ThemeData.dark(),
          child: widget!,
        );
      },
    );
    if (datetime != null) {
      _dateController.text = datetime.toString().substring(0, 10);
      setState(() {});
    }
  }

  registerTask() {
    if (formKey.currentState!.validate()) {
      TaskModel taskModel = TaskModel(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        category: categorySelected,
        status: true,
      );
      taskService.addTask(taskModel).then((value) {
        if (value.isNotEmpty) {
          Navigator.pop(context);
          showSnackBarSuccess(context, "La tarea fue registrada con éxito");
        }
      }).catchError((error) {
        showSnackBarError(
            context, "Hubo un inconveniente , intentalo otra vez");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22.0),
          topRight: Radius.circular(22.0),
        ),
      ),
      padding: const EdgeInsets.all(14.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Agregar Tarea",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            divider6(),
            TextFieldNormalWidget(
              hintText: "Titulo",
              icon: Icons.text_fields,
              controller: _titleController,
            ),
            divider10(),
            TextFieldNormalWidget(
              hintText: "Description",
              icon: Icons.description,
              controller: _descriptionController,
            ),
            divider10(),
            const Text("Categoria: "),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 10.0,
              children: [
                FilterChip(
                  selected: categorySelected == "Personal",
                  backgroundColor: KBrandSecondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  selectedColor: categoryColor[categorySelected],
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: categorySelected == "Personal"
                        ? Colors.white
                        : KBrandPrimaryColor,
                  ),
                  label: Text("Personal"),
                  onSelected: (bool value) {
                    categorySelected = "Personal";
                    setState(() {});
                  },
                ),
                FilterChip(
                  selected: categorySelected == "Trabajo",
                  backgroundColor: KBrandSecondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  selectedColor: categoryColor[categorySelected],
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: categorySelected == "Trabajo"
                        ? Colors.white
                        : KBrandPrimaryColor,
                  ),
                  label: Text("Trabajo"),
                  onSelected: (bool value) {
                    categorySelected = "Trabajo";
                    setState(() {});
                  },
                ),
                FilterChip(
                  selected: categorySelected == "Otro",
                  backgroundColor: KBrandSecondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  selectedColor: categoryColor[categorySelected],
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: categorySelected == "Otro"
                        ? Colors.white
                        : KBrandPrimaryColor,
                  ),
                  label: Text("Otro"),
                  onSelected: (bool value) {
                    categorySelected = "Otro";
                    setState(() {});
                  },
                ),
              ],
            ),
            divider10(),
            TextFieldNormalWidget(
              hintText: "Fecha",
              icon: Icons.date_range,
              controller: _dateController,
              onTap: () {
                showSelectDate();
              },
            ),
            ButtonNormalWidget(
              onPressed: () {
                registerTask();
              },
            ),
            divider10(),
          ],
        ),
      ),
    );
  }
}
