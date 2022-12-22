import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase/models/task_model.dart';
import 'package:firebase/pages/login_page.dart';
import 'package:firebase/ui/general/colors.dart';
import 'package:firebase/ui/widgets/button_normal_widget.dart';
import 'package:firebase/ui/widgets/general_widgets.dart';
import 'package:firebase/ui/widgets/item_task_widget.dart';
import 'package:firebase/ui/widgets/task_form_widget.dart';
import 'package:firebase/ui/widgets/textFlied_normal_widget.dart';
import 'package:firebase/utils/task_search_delegate.dart';

class HomePage extends StatelessWidget {
  List<TaskModel> tasksGeneral = [];

  final TextEditingController _searchController = TextEditingController();
  CollectionReference taskReference =
      FirebaseFirestore.instance.collection("tasks");

  showTaskForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Taskformwidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBrandSecondaryColor,
      floatingActionButton: InkWell(
        onTap: () {
          showTaskForm(context);
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: KBrandPrimaryColor,
            borderRadius: BorderRadius.circular(
              14,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                "Agregar nueva tarea",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(4, 4),
                  )
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Bienvenido ,Ramón",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: KBrandPrimaryColor,
                              ),
                            ),
                            Text(
                              "Mis Tareas",
                              style: TextStyle(
                                fontSize: 36.0,
                                fontWeight: FontWeight.w600,
                                color: KBrandPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                          ),
                        ),
                      ],
                    ),
                    divider10(),
                    TextFieldNormalWidget(
                      onTap: () async {
                        await showSearch(
                          context: context,
                          delegate: TaskSearchDelegate(tasks: tasksGeneral),
                        );
                      },
                      hintText: "Buscar Tarea ...",
                      icon: Icons.search,
                      controller: _searchController,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Todas mis tareas",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: KBrandPrimaryColor.withOpacity(0.85),
                    ),
                  ),
                  StreamBuilder(
                    stream: taskReference.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        List<TaskModel> tasks = [];
                        QuerySnapshot collection = snap.data;
                        /*metodo 1
                        collection.docs.forEach((element) {
                          Map<String, dynamic> myMap =
                              element.data() as Map<String, dynamic>;
                          tasks.add(TaskModel.fromJson(myMap));
                        });*/
                        /*Metodo2
                        tasks = collection.docs
                            .map(
                              (e) => TaskModel.fromJson(
                                e.data() as Map<String, dynamic>,
                              ),
                            )
                            .toList();*/
                        tasks = collection.docs.map((e) {
                          TaskModel task = TaskModel.fromJson(
                              e.data() as Map<String, dynamic>);
                          task.id = e.id;
                          return task;
                        }).toList();
                        tasksGeneral.clear();
                        tasksGeneral = tasks;

                        return ListView.builder(
                          itemCount: tasks.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return ItemTaskWidget(
                              taskModel: tasks[index],
                            );
                          },
                        );
                      }
                      return loadingWidget();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*body: StreamBuilder(
        stream: taskReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            QuerySnapshot collection = snap.data;
            List<QueryDocumentSnapshot> docs = collection.docs;
            List<Map<String, dynamic>> docsMap =
                docs.map((e) => e.data() as Map<String, dynamic>).toList();
            print(docsMap);
            return ListView.builder(
              itemCount: docsMap.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(docsMap[index]["title"]),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),*/
    );
  }
}
