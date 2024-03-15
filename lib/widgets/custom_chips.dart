
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo/cubit/to_do_cubit.dart';
import 'package:todo/data/provider.dart';
import 'package:todo/models/enum.dart';
import 'package:todo/models/todo_model.dart';

class CustomChips {
  void showPopupAnimsat(
      BuildContext context,
      double dx,
      double dy,
      ToDoProvider provider,
      Enum fromScreen,
      int? index,
      List<ToDoModel>? toDoList,
      String? tableName) {
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
        PopupMenuItem(
          onTap: () {
            DateTime nowDate = DateTime.now();

            if (fromScreen == Enums.inSubmitScreen) {
              if (nowDate.hour < 12) {
                
                provider.changeScheduleTime(DateTime(
                    nowDate.year, nowDate.month, nowDate.day, 12, 00));
                provider.changetoDoDate(
                    '${nowDate.day}/${nowDate.month}/${nowDate.year}');
                provider.changetoDoTime('12:00');
                provider.changeChip1(true);
              } else if (nowDate.hour < 19) {
               
                provider.changeScheduleTime(DateTime(
                    nowDate.year, nowDate.month, nowDate.day, 19, 00));
                provider.changetoDoDate(
                    '${nowDate.day}/${nowDate.month}/${nowDate.year}');
                provider.changetoDoTime('19:00');
                provider.changeChip1(true);
              } else if (nowDate.hour < 23) {
                
                provider.changeScheduleTime(DateTime(
                    nowDate.year, nowDate.month, nowDate.day, 23, 00));
                provider.changetoDoDate(
                    '${nowDate.day}/${nowDate.month}/${nowDate.year}');
                provider.changetoDoTime('23:00');
                provider.changeChip1(true);
              }
            } else if (fromScreen == Enums.inDetailScreen) {
              if (nowDate.hour < 12) {
                DateTime newDate =
                    DateTime(nowDate.year, nowDate.month, nowDate.day, 12, 00);
                var newToDo = toDoList![index!].copyWith(
                    schedule:
                        "${newDate.day}/${newDate.month}/${newDate.year} ${newDate.hour}:${newDate.minute}");
                toDoList[index] = newToDo;
                context
                    .read<ToDoCubit>()
                    .changeToDo(toDoList, newToDo, tableName!);
              } else if ( nowDate.hour < 19) {
                DateTime newDate =
                    DateTime(nowDate.year, nowDate.month, nowDate.day, 19, 00);
                var newToDo = toDoList![index!].copyWith(
                    schedule:
                        "${newDate.day}/${newDate.month}/${newDate.year} ${newDate.hour}:${newDate.minute}");
                toDoList[index] = newToDo;
                context
                    .read<ToDoCubit>()
                    .changeToDo(toDoList, newToDo, tableName!);
              } else if (nowDate.hour < 23) {
                DateTime newDate =
                    DateTime(nowDate.year, nowDate.month, nowDate.day, 23, 00);
                var newToDo = toDoList![index!].copyWith(
                    schedule:
                        "${newDate.day}/${newDate.month}/${newDate.year} ${newDate.hour}:${newDate.minute}");
                toDoList[index] = newToDo;
                context
                    .read<ToDoCubit>()
                    .changeToDo(toDoList, newToDo, tableName!);
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time_filled_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Bugün içinde"),
                ],
              ),
              Builder(builder: (context) {
                DateTime nowDate = DateTime.now();

                if (nowDate.hour <= 12) {
                  DateTime newDate = DateTime(
                      nowDate.year, nowDate.month, nowDate.day, 12, 00);

                  return Text('${newDate.hour}:${newDate.minute}0');
                } else if (nowDate.hour >= 19) {
                  DateTime newDate = DateTime(
                      nowDate.year, nowDate.month, nowDate.day, 23, 00);

                  return Text('${newDate.hour}:${newDate.minute}0');
                } else if (nowDate.hour >= 23) {
                  DateTime newDate = DateTime(
                      nowDate.year, nowDate.month, nowDate.day, 23, 30);

                  return Text('${newDate.hour}:${newDate.minute}0');
                }
                return const Text("hata");
              }),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            DateTime nowDate = DateTime.now();

            if (fromScreen == Enums.inSubmitScreen) {
              provider.changeScheduleTime(DateTime(
                  nowDate.year, nowDate.month, nowDate.day + 1, 12, 00));
              provider.changetoDoDate(
                  '${nowDate.day + 1}/${nowDate.month}/${nowDate.year}');
              provider.changetoDoTime('12:00');
              provider.changeChip1(true);
            } else if (fromScreen == Enums.inDetailScreen) {
              DateTime newDate = DateTime(
                  nowDate.year, nowDate.month, nowDate.day + 1, 12, 00);
              var newToDo = toDoList![index!].copyWith(
                  schedule:
                      "${newDate.day}/${newDate.month}/${newDate.year} ${newDate.hour}:${newDate.minute}");
              toDoList[index] = newToDo;
              context
                  .read<ToDoCubit>()
                  .changeToDo(toDoList, newToDo, tableName!);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.next_plan),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Yarın "),
                ],
              ),
              Builder(builder: (context) {
                DateTime nowDate = DateTime.now();

                DateTime newDate = DateTime(
                    nowDate.year, nowDate.month, nowDate.day + 1, 12, 00);
                String haftaninGunu = DateFormat('EEEE').format(newDate);
                return Text('$haftaninGunu ${newDate.hour}:${newDate.minute}0');
              }),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            DateTime nowDate = DateTime.now();
            if (fromScreen == Enums.inSubmitScreen) {
              provider.changeScheduleTime(DateTime(
                  nowDate.year, nowDate.month, nowDate.day + 7, 12, 00));
              provider.changetoDoDate(
                  '${nowDate.day + 7}/${nowDate.month}/${nowDate.year}');
              provider.changetoDoTime('12:00');
              provider.changeChip1(true);
            } else if (fromScreen == Enums.inDetailScreen) {
              DateTime newDate = DateTime(
                  nowDate.year, nowDate.month, nowDate.day + 7, 12, 00);
              var newToDo = toDoList![index!].copyWith(
                  schedule:
                      "${newDate.day}/${newDate.month}/${newDate.year} ${newDate.hour}:${newDate.minute}");
              toDoList[index] = newToDo;
              context
                  .read<ToDoCubit>()
                  .changeToDo(toDoList, newToDo, tableName!);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.double_arrow_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Gelecek hafta"),
                ],
              ),
              Builder(builder: (context) {
                DateTime nowDate = DateTime.now();

                DateTime newDate = DateTime(
                    nowDate.year, nowDate.month, nowDate.day + 7, 12, 00);
                String haftaninGunu = DateFormat('EEEE').format(newDate);
                return Text('$haftaninGunu ${newDate.hour}:${newDate.minute}0');
              }),
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
                if (fromScreen == Enums.inSubmitScreen) {
                  provider.changeScheduleDate(
                      DateTime(dateTime.year, dateTime.month, dateTime.day));
                  provider.changeChip1(true);
                  provider.changetoDoDate(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year}');
                } else if (fromScreen == Enums.inDetailScreen) {
                  provider.changeCacheDate(
                      DateTime(dateTime.year, dateTime.month, dateTime.day));
                }

                return true;
              },

              /* onTapActionButton: () {
              
              
              },  */
            ).then((value) {
              Navigator.of(context).push(
                showPicker(
                  is24HrFormat: false,
                  context: context,
                  value: Time.fromTimeOfDay(TimeOfDay.now(), 1),
                  sunrise: const TimeOfDay(hour: 6, minute: 0), // optional
                  sunset: const TimeOfDay(hour: 18, minute: 0), // optional
                  duskSpanInMinutes: 120, // optional

                  onChange: (time) {
                    if (fromScreen == Enums.inSubmitScreen) {
                      DateTime date = provider.getschedule;
                      provider.changeScheduleTime(DateTime(date.year,
                          date.month, date.day, time.hour, time.minute));
                      provider.changetoDoTime('${time.hour}:${time.minute}');
                    } else if (fromScreen == Enums.inDetailScreen) {
                      provider.changeCacheTime(
                          Time(hour: time.hour, minute: time.minute));
                      DateTime cacheSchedule = provider.getcacheSchedule;
                      var newToDo = toDoList![index!].copyWith(
                          schedule:
                              "${cacheSchedule.day}/${cacheSchedule.month}/${cacheSchedule.year} ${cacheSchedule.hour}:${cacheSchedule.minute}");
                      toDoList[index] = newToDo;
                      context
                          .read<ToDoCubit>()
                          .changeToDo(toDoList, newToDo, tableName!);
                    }
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
  }
}
