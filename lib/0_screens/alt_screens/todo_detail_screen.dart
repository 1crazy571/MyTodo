import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_checkbox/icon_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/data/provider.dart';
import 'package:todo/models/enum.dart';
import 'package:todo/models/todo_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/widgets/custom_chips.dart';

// ignore: must_be_immutable
class ToDoDetailScreen extends StatefulWidget {
  ToDoDetailScreen({super.key, required this.index, required this.tableName});

  int index;
  String tableName;

  @override
  State<ToDoDetailScreen> createState() => _ToDoDetailScreenState();
}

class _ToDoDetailScreenState extends State<ToDoDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset? tapXY;
  // ↓ hold screen size, using first line in build() method

  @override
  void initState() {
    super.initState();
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
    return BlocBuilder<ToDoCubit, List<ToDoModel>>(
      builder: (context, toDoList) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: PopScope(
                canPop: true,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back))),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (toDoList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ListTile(
                      leading: Checkbox(
                        value: toDoList[widget.index].isdone == "true"
                            ? true
                            : false,
                        onChanged: (value) {
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
                      trailing: IconCheckbox(
                              checkedIcon: Icons.star,
                              uncheckedIcon: Icons.star_border,
                              checkColor: Colors.yellow,
                              value:
                                  toDoList[widget.index].isimportant == "true"
                                      ? true
                                      : false,
                              onChanged: (value) {
                                var newToDo = toDoList[widget.index]
                                    .copyWith(isimportant: value.toString());
                                toDoList[widget.index] = newToDo;
                                context.read<ToDoCubit>().changeToDo(
                                    toDoList, newToDo, widget.tableName);

                                _controller.forward();
                                Future.delayed(
                                  const Duration(milliseconds: 222),
                                  () {
                                    _controller.reverse();
                                  },
                                );
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
                if (toDoList.isNotEmpty)
                  Consumer<ToDoProvider>(
                    builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Card(
                                          elevation: 3,
                                          shape: const Border(),
                                          clipBehavior: Clip.hardEdge,
                                          child: ListTile(
                                            onTap: () {
                                              print(widget.tableName);
                                              var newToDo = toDoList[
                                                      widget.index]
                                                  .copyWith(
                                                      istoday: toDoList[widget
                                                                      .index]
                                                                  .istoday ==
                                                              "true"
                                                          ? "false"
                                                          : "true");
                                              toDoList[widget.index] = newToDo;
                                              context
                                                  .read<ToDoCubit>()
                                                  .changeToDo(toDoList, newToDo,
                                                      widget.tableName);
                                            },
                                            leading: const Icon(Icons.sunny),
                                            title: toDoList[widget.index]
                                                        .istoday ==
                                                    "true"
                                                ? Text(AppLocalizations.of(
                                                        context)!
                                                    .isInToday)
                                                : Text(AppLocalizations.of(
                                                        context)!
                                                    .isNotInToday),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTapDown: (details) {
                                      var renderBox = provider.getRenderBox;
                                      final localPosition = renderBox!
                                          .globalToLocal(
                                              details.globalPosition);
                                      CustomChips().showPopupAnimsat(
                                          context,
                                          localPosition.dx,
                                          localPosition.dy,
                                          provider,
                                          Enums.inDetailScreen,
                                          widget.index,
                                          toDoList,
                                          widget.tableName);
                                    },
                                    child: Card(
                                      elevation: 3,
                                      shape: const Border(),
                                      clipBehavior: Clip.hardEdge,
                                      child: ListTile(
                                        /* onTap: () {
                                          
                                        }, */
                                        title: toDoList[widget.index]
                                                .schedule
                                                .isEmpty
                                            ? const Text("Bana anımsat")
                                            : Text(
                                                toDoList[widget.index].schedule,
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue.shade500)),
                                        leading:
                                            const Icon(Icons.notifications),
                                        trailing: toDoList[widget.index]
                                                .schedule
                                                .isNotEmpty
                                            ? IconButton(
                                                onPressed: () {
                                                  var newToDo =
                                                      toDoList[widget.index]
                                                          .copyWith(
                                                              schedule: "");

                                                  toDoList[widget.index] =
                                                      newToDo;

                                                  context
                                                      .read<ToDoCubit>()
                                                      .changeToDo(
                                                          toDoList,
                                                          newToDo,
                                                          widget.tableName);

                                                  AwesomeNotifications().cancel(
                                                      toDoList[widget.index]
                                                          .id!);
                                                },
                                                icon: const Icon(Icons.close))
                                            : null,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTapDown: (details) {
                                      var renderBox = provider.getRenderBox;
                                      final localPosition = renderBox!
                                          .globalToLocal(
                                              details.globalPosition);
                                      CustomChips().showPopupDate(
                                        context,
                                        localPosition.dx,
                                        localPosition.dy,
                                      );
                                    },
                                    child: const Card(
                                      elevation: 3,
                                      shape: Border(),
                                      clipBehavior: Clip.hardEdge,
                                      child: ListTile(
                                        title: Text("Son Tarih Ekle"),
                                        leading: Icon(Icons.notifications),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Card(
                                              elevation: 3,
                                              shape: const Border(),
                                              clipBehavior: Clip.hardEdge,
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                maxLines: 5,
                                                initialValue:
                                                    toDoList[widget.index].text,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .detailNote,
                                                    border: InputBorder.none),
                                                /* onSaved: (newValue) {
                                          
                                        }, */
                                                onFieldSubmitted: (value) {
                                                  var currunetToDo =
                                                      toDoList[widget.index];
                                                  var newToDo = currunetToDo
                                                      .copyWith(text: value);
                                                  context
                                                      .read<ToDoCubit>()
                                                      .changeToDo(
                                                          toDoList,
                                                          newToDo,
                                                          widget.tableName);
                                                },
                                              )))
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
