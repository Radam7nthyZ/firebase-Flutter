import 'package:flutter/material.dart';
import 'package:firebase/models/task_model.dart';
import 'package:firebase/services/my_service_firestore.dart';
import 'package:firebase/ui/widgets/item_category_widget.dart';

import '../general/colors.dart';
import 'general_widgets.dart';

class ItemTaskWidget extends StatelessWidget {
  TaskModel taskModel;

  ItemTaskWidget({required this.taskModel});
  MyServiceFirestore _myServiceFirestore =
      MyServiceFirestore(collection: "tasks");

  showFinishDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Finalizar tarea",
                style: TextStyle(
                  color: KBrandPrimaryColor.withOpacity(0.87),
                  fontWeight: FontWeight.w600,
                ),
              ),
              divider6(),
              Text(
                "¿Deseas finalizar la tarea tarea seleccionada?",
                style: TextStyle(
                  color: KBrandPrimaryColor.withOpacity(0.87),
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        color: KBrandPrimaryColor.withOpacity(0.87),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  divider10Width(),
                  ElevatedButton(
                    onPressed: () {
                      _myServiceFirestore.finishedTask(taskModel.id!);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KBrandPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: Text(
                      "Finalizar",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(4, 4),
            blurRadius: 12.0,
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemCategoryWidget(
                text: taskModel.category,
              ),
              divider3(),
              Text(
                taskModel.title,
                style: TextStyle(
                  decoration: taskModel.status
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: KBrandPrimaryColor.withOpacity(0.85),
                ),
              ),
              Text(
                taskModel.description,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: KBrandPrimaryColor.withOpacity(0.75),
                ),
              ),
              divider6(),
              Text(
                taskModel.date,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: KBrandPrimaryColor.withOpacity(0.75),
                ),
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -12,
            child: PopupMenuButton(
              onSelected: (value) {
                if (value == 2) {
                  showFinishDialog(context);
                }
              },
              elevation: 2,
              color: Colors.white,
              icon: Icon(
                Icons.more_vert,
                color: KBrandPrimaryColor.withOpacity(0.85),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Editar",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: KBrandPrimaryColor.withOpacity(0.85),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      "Finalizar",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: KBrandPrimaryColor.withOpacity(0.85),
                      ),
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}
