import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_checkbox/icon_checkbox.dart';
import 'package:todo/0_screens/alt_screens/todo_detail_screen.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/data/database.dart';
import 'package:todo/models/todo_model.dart';

// ignore: must_be_immutable
class ToDoItem extends StatefulWidget {
  ToDoItem({
    super.key,
    required this.index,
    required this.whichPage,
  })  : tableName = "ToDo",
        comingfromCustom = false,
        primaryColor = 0xFF2196F3;

  ToDoItem.fromCustom({
    super.key,
    required this.index,
    required this.whichPage,
    required this.tableName,
    required this.primaryColor,
  }) : comingfromCustom = true;

  int index;
  String whichPage;
  String tableName;
  int primaryColor;
  bool comingfromCustom;
  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem>
    with SingleTickerProviderStateMixin {
  UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();
  late AnimationController _controller;
  bool checkbox = false;

  @override
  void initState() {
    super.initState();
    if (widget.tableName.isNotEmpty) {
      userDatabaseProvider.getListOfModel(widget.tableName);
    }
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.3,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.primaryColor);
    return BlocBuilder<ToDoCubit, List<ToDoModel>>(
      builder: (context, toDoList) {
        return Column(
          children: [
            Dismissible(
              onDismissed: (direction) {
                userDatabaseProvider.delete(
                  toDoList[widget.index].id!,
                  widget.tableName,
                );
                context
                    .read<ToDoCubit>()
                    .removeToDo(toDoList, toDoList[widget.index]);

                /*  */
                /*  userDatabaseProvider.getTodayListLength(); */
              },
              key: UniqueKey(),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                elevation: 5,
                clipBehavior: Clip.hardEdge,
                key: UniqueKey(),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ToDoDetailScreen(
                          index: widget.index,
                          tableName: widget.tableName,
                        ),
                      ),
                    )
                        .then((value) {
                      if (widget.whichPage == "today") {
                        context
                            .read<ToDoCubit>()
                            .fetchDataFromDatabaseIsToday(widget.tableName);
                      } else if (widget.whichPage == "important") {
                        context
                            .read<ToDoCubit>()
                            .fetchDataFromDatabaseImportant(widget.tableName);
                      } else if (widget.whichPage == "scheduled") {
                        context
                            .read<ToDoCubit>()
                            .fetchDataFromDatabaseScheduled(widget.tableName);
                      } else if (widget.whichPage == "ToDo") {
                        context
                            .read<ToDoCubit>()
                            .fetchDataFromDatabase(widget.tableName);
                      }else if (widget.whichPage == "customToDo") {
                        context
                            .read<ToDoCubit>()
                            .fetchDataFromDatabase(widget.tableName);
                      }
                    });
                  },
                  key: UniqueKey(),
                  leading: Checkbox(
                    checkColor: Colors.white,
                    activeColor: Color(widget.primaryColor),
                    value:
                        toDoList[widget.index].isdone == "true" ? true : false,
                    onChanged: (value) {
                      checkbox = value!;
                      var newToDo = toDoList[widget.index]
                          .copyWith(isdone: value.toString());
                      toDoList[widget.index] = newToDo;
                      context
                          .read<ToDoCubit>()
                          .changeToDo(toDoList, newToDo, widget.tableName);
                    },
                  ),
                  title: toDoList[widget.index].isdone == "true"
                      ? Text(toDoList[widget.index].title,
                          style: const TextStyle(
                              decoration: TextDecoration.lineThrough))
                      : Text(
                          toDoList[widget.index].title,
                        ),
                  subtitle: throwBackSubtitle(toDoList),
                  trailing: IconCheckbox(
                          checkedIcon: Icons.star,
                          uncheckedIcon: Icons.star_border,
                          checkColor: widget.comingfromCustom
                              ? Color(widget.primaryColor)
                              : Colors.yellow,
                          value: toDoList[widget.index].isimportant == "true"
                              ? true
                              : false,
                          onChanged: (value) {
                            setState(() {
                              var newToDo = toDoList[widget.index]
                                  .copyWith(isimportant: value.toString());
                              toDoList[widget.index] = newToDo;
                              context.read<ToDoCubit>().changeToDo(
                                  toDoList, newToDo, widget.tableName);
                              if (widget.whichPage == "today") {
                                context
                                    .read<ToDoCubit>()
                                    .fetchDataFromDatabaseIsToday(
                                        widget.tableName);
                              } else if (widget.whichPage == "scheduled") {
                                context
                                    .read<ToDoCubit>()
                                    .fetchDataFromDatabaseScheduled(
                                        widget.tableName);
                              } else if (widget.whichPage == "important") {
                                if (value == false) {
                                  context
                                      .read<ToDoCubit>()
                                      .fetchDataFromDatabaseImportant(
                                          widget.tableName);
                                }
                              } else if (widget.whichPage == "ToDo") {
                                context
                                    .read<ToDoCubit>()
                                    .fetchDataFromDatabase(widget.tableName);
                              }

                              _controller.forward();
                              Future.delayed(
                                const Duration(milliseconds: 222),
                                () {
                                  _controller.reverse();
                                },
                              );
                            });
                          })
                      .animate(
                        controller: _controller,
                        autoPlay: false,
                      )
                      .scale(
                        end: const Offset(1.4, 1.4),
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Text? throwBackSubtitle(List<ToDoModel> toDoList) {
    if (toDoList[widget.index].schedule.isNotEmpty ||
        toDoList[widget.index].text.isNotEmpty) {
      return toDoList[widget.index].isdone == "true"
          ? Text(
              '${toDoList[widget.index].text} ${toDoList[widget.index].schedule}',
              style: const TextStyle(decoration: TextDecoration.lineThrough),
            )
          : Text(
              '${toDoList[widget.index].text} ${toDoList[widget.index].schedule}');
    } else {
      return null;
    }
  }
}
