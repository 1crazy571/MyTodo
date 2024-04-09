// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/data/database.dart';
import 'package:todo/data/provider.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/widgets/todo_submit.dart';

import '../widgets/todo_item.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();
  String today = "ToDoa";
  bool checkbox = false;
  late final FocusNode myfocusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    userDatabaseProvider.initialize().then((value) {
      context.read<ToDoCubit>().fetchDataFromDatabase("ToDo");
    });
  }

  @override
  Widget build(BuildContext context) {
    bool bottomAddWidget = context.watch<ToDoProvider>().getbottomAddWidget;
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return BlocBuilder<ToDoCubit, List<ToDoModel>>(
      builder: (context, toDoList) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: !bottomAddWidget
              ? PhysicalModel(
                  color: Colors.black,
                  elevation: 6,
                  shadowColor: Colors.grey,
                  borderRadius: BorderRadius.circular(44),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(

                        /* boxShadow: const [
                          BoxShadow(offset: Offset(5, 10), blurRadius: 33,)
                        ], */
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(28)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        onTap: () {
                          context
                              .read<ToDoProvider>()
                              .changeBottomWidget(!bottomAddWidget);
                          Future.delayed(
                            const Duration(milliseconds: 15),
                            () => FocusScope.of(context)
                                .requestFocus(myfocusnode),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          appBar: AppBar(foregroundColor: Theme.of(context).colorScheme.onBackground,
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              PopupMenuButton(
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  const PopupMenuItem(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("asdsa"),
                    ),
                  ),
                ],
              )
            ],
          ),
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: throwBackItemCount(toDoList.length),
                    itemBuilder: (BuildContext context, int index) {
                      return throwBackItemWidget(
                          index, toDoList.length, isDarkMode);
                    },
                  ),
                ),
                if (bottomAddWidget)
                  Positioned(
                    bottom: 0,
                    child: ToDoSubmit(
                      whichPage: "ToDo",
                      tableName: "ToDo",
                      backgroundColor: 0xFFFFFFFF,
                      focusnode: myfocusnode,
                      primaryColor: 0xFF2196F3,
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  int throwBackItemCount(int itemlength) {
    if (itemlength < 1) {
      return itemlength + 12;
    } else if (itemlength < 2) {
      return itemlength + 11;
    } else if (itemlength < 3) {
      return itemlength + 10;
    } else if (itemlength < 4) {
      return itemlength + 9;
    } else if (itemlength < 5) {
      return itemlength + 8;
    } else if (itemlength < 6) {
      return itemlength + 7;
    } else if (itemlength < 7) {
      return itemlength + 6;
    } else if (itemlength < 8) {
      return itemlength + 5;
    } else if (itemlength < 9) {
      return itemlength + 4;
    } else if (itemlength < 10) {
      return itemlength + 3;
    } else if (itemlength < 11) {
      return itemlength + 2;
    } else if (itemlength < 12) {
      return itemlength + 1;
    } else {
      return itemlength;
    }
  }

  Widget throwBackItemWidget(int index, int itemlength, bool isDarkMode) {
    if (itemlength > index) {
      return ToDoItem(
        index: index,
        whichPage: "ToDo",
      );
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 52,
          ),
          Divider(
            indent: 22,
            endIndent: 22,
            color: !isDarkMode
                ? Theme.of(context).colorScheme.onBackground
                : Colors.white,
            height: 5,
          )
        ],
      );
    }
  }
}
