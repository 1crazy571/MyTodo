import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/data/provider.dart';
import 'package:todo/models/enum.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/widgets/custom_chips.dart';

// ignore: must_be_immutable
class ToDoSubmit extends StatefulWidget {
  ToDoSubmit(
      {super.key,
      required this.tableName,
      required this.backgroundColor,
      required this.focusnode,
      required this.primaryColor,
      required this.whichPage});

  ToDoSubmit.fromCustom(
      {super.key,
      required this.tableName,
      required this.backgroundColor,
      required this.focusnode,
      required this.primaryColor})
      : whichPage = "customToDo";

  String tableName;
  int backgroundColor;
  int primaryColor;
  FocusNode focusnode;
  String whichPage;

  @override
  State<ToDoSubmit> createState() => _ToDoSubmitState();
}

class _ToDoSubmitState extends State<ToDoSubmit> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.focusnode = widget.focusnode ?? FocusNode();
    widget.focusnode.addListener(() {
      if (!widget.focusnode.hasFocus) {
        if (mounted) {
          context.read<ToDoProvider>().changeBottomWidget(false);
        }
        print('TextField odak durumunu kaybetti');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int day = 0, month = 0, year = 0, hour = 0, minute = 0;
    return Consumer<ToDoProvider>(
      builder: (c, provider, child) {
        return Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: sendBottomSheet(
                    context, provider, day, month, year, hour, minute),
              ),
            )
          ],
        );
      },
    );
  }

  Widget sendBottomSheet(BuildContext context, ToDoProvider provider, int day,
      int month, int year, int hour, int minute) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  focusNode: widget.focusnode,
                  controller: _controller,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Add ToDo"),
                  onChanged: (value) {
                    provider.changetoDoTitle(value);
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    submitToDo(provider, context);
                    context.read<ToDoProvider>().changeBottomWidget(false);
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(widget.primaryColor)),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: provider.getischip1selected
                          ? Colors.blue[100]
                          : Colors.grey[200],
                    ),
                    child: InkWell(
                      onTapDown: (details) {
                        var renderBox = provider.getRenderBox;
                        final localPosition =
                            renderBox!.globalToLocal(details.globalPosition);
                        CustomChips().showPopupAnimsat(
                            context,
                            localPosition.dx,
                            localPosition.dy,
                            provider,
                            Enums.inSubmitScreen,
                            null,
                            null,
                            null);
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Icon(Icons.notifications,color: Theme.of(context).colorScheme.onSurface,),
                            const SizedBox(
                              width: 5,
                            ),
                             Text("Bana anımsat",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                            if (provider.getischip1selected)
                              SizedBox(
                                height: 22,
                                width: 24,
                                child: IconButton(
                                    iconSize: 17,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      provider.changeChip1(false);
                                      provider.deletecache();
                                    },
                                    icon: const Icon(Icons.close)),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Material(
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTapDown: (details) {
                      var renderBox = provider.getRenderBox;
                      final localPosition =
                          renderBox!.globalToLocal(details.globalPosition);
                      CustomChips().showPopupDate(
                          context, localPosition.dx, localPosition.dy);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.grey[200]),
                      width: 140,
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Icon(Icons.date_range_outlined,color:Theme.of(context).colorScheme.onSurface ,),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("Son tarih ekle",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void submitToDo(ToDoProvider provider, BuildContext context) async {
    provider.changeChip1(false);
    ToDoModel toDo = provider.getToDo();
    var newToDo = toDo.copyWith(tablename: widget.tableName);
    context
        .read<ToDoCubit>()
        .submitToDo(newToDo, widget.tableName)
        .then((id) async {
      /*  print(provider.getschedule);
      print(widget.tableName);
      print(id); */

      var text = provider.gettoDoText;
      var title = provider.gettoDoTitle;

      try {
        AwesomeNotifications().createNotification(
          schedule:
              NotificationAndroidCrontab.fromDate(date: provider.getschedule),
          content: NotificationContent(
            id: id,
            channelKey: "basic_channel",
            title: "title: $title",
            body: "body: $text",
            payload: {"tablename": widget.tableName},
          ),
        );
      } catch (e) {
        debugPrint("error: $e");
      }
    });

    Future.delayed(
      const Duration(seconds: 2),
      () {
        provider.deletecache();
      },
    );
    _controller.text = "";
    /* print(widget.tableName); */
    if (widget.whichPage == "today") {
      context.read<ToDoCubit>().fetchDataFromDatabaseIsToday(widget.tableName);
    } else if (widget.whichPage == "important") {
      context
          .read<ToDoCubit>()
          .fetchDataFromDatabaseImportant(widget.tableName);
    } else if (widget.whichPage == "scheduled") {
      context
          .read<ToDoCubit>()
          .fetchDataFromDatabaseScheduled(widget.tableName);
    } else if (widget.whichPage == "ToDo") {
      context.read<ToDoCubit>().fetchDataFromDatabase(widget.tableName);
    } else if (widget.whichPage == "customToDo") {
      context.read<ToDoCubit>().fetchDataFromDatabase(widget.tableName);
    }
  }

  /* void showPopupAnimsat(
      BuildContext context, double dx, double dy, ToDoProvider provider) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(dx, dy - 220), // Yazıya tıkladığınız koordinatı buraya ekleyin
        Offset(dx, dy - 220), // Menünün açılacağı koordinatı buraya ekleyin
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.access_time_filled_sharp),
              SizedBox(
                width: 10,
              ),
              Text('Bugün içinde'),
            ],
          ),
        ),
        const PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.next_plan),
              SizedBox(
                width: 10,
              ),
              Text('Yarın'),
            ],
          ),
        ),
        const PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.double_arrow_rounded),
              SizedBox(
                width: 10,
              ),
              Text('Gelecek hafta'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            showRoundedDatePicker(
              context: context,
              initialDate: DateTime.now(),
              theme: ThemeData.light(),
              firstDate: DateTime(DateTime.now().year - 1),
              lastDate: DateTime(DateTime.now().year + 1),
              borderRadius: 22,
              onTapDay: (dateTime, available) {
                provider.changeDate(
                    DateTime(dateTime.year, dateTime.month, dateTime.day));
                provider.changeChip1(true);
                provider.changetoDoDate(
                    '${dateTime.day}/${dateTime.month}/${dateTime.year}');
                return true;
              },

              /* onTapActionButton: () {
              
              
              },  */
            ).then((value) {
              Navigator.of(context).push(
                showPicker(
                  context: context,
                  value: Time.fromTimeOfDay(TimeOfDay.now(), 1),
                  sunrise: const TimeOfDay(hour: 6, minute: 0), // optional
                  sunset: const TimeOfDay(hour: 18, minute: 0), // optional
                  duskSpanInMinutes: 120, // optional

                  onChange: (time) {
                    DateTime date = provider.getschedule;
                    provider.changeTime(DateTime(date.year, date.month,
                        date.day, time.hour, time.minute));
                    provider.changetoDoTime('${time.hour}:${time.minute}');
                  },
                ),
              );
            });
          },
          value: 2,
          child: const Row(
            children: [
              Divider(height: 5),
              Icon(Icons.date_range),
              SizedBox(
                width: 10,
              ),
              Text('Tarih ve saat seçin'),
            ],
          ),
        )
      ],
      elevation: 8,
    );
    _myfocusnode.requestFocus();
  }
}

void showPopupDate(BuildContext context, double dx, double dy) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      Offset(dx, dy - 220), // Yazıya tıkladığınız koordinatı buraya ekleyin
      Offset(dx, dy - 220), // Menünün açılacağı koordinatı buraya ekleyin
    ),
    Offset.zero & overlay.size,
  );

  showMenu(
    context: context,
    position: position,
    items: <PopupMenuEntry>[
      const PopupMenuItem(
        value: 1,
        child: Row(
          children: [
            Icon(Icons.access_time_filled_sharp),
            SizedBox(
              width: 10,
            ),
            Text('Bugün'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 2,
        child: Row(
          children: [
            Icon(Icons.next_plan),
            SizedBox(
              width: 10,
            ),
            Text('Yarın'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 2,
        child: Row(
          children: [
            Icon(Icons.double_arrow_rounded),
            SizedBox(
              width: 10,
            ),
            Text('Gelecek hafta'),
          ],
        ),
      ),
      PopupMenuItem(
        onTap: () {
          showRoundedDatePicker(
            context: context,
            initialDate: DateTime.now(),
            theme: ThemeData.light(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 22,
          );
          /* showTimePicker(context: context, initialTime: TimeOfDay.now()); */
        },
        value: 2,
        child: const Row(
          children: [
            Divider(height: 5),
            Icon(Icons.date_range),
            SizedBox(
              width: 10,
            ),
            Text('Tarih seçin'),
          ],
        ),
      )
    ],
    elevation: 8,
  ).then((value) {
    if (value == 1) {
      // Seçenek 1'e tıklanınca yapılacak işlemler
    } else if (value == 2) {
      // Seçenek 2'ye tıklanınca yapılacak işlemler
    }
  });
} */
}
