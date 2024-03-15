// ignore_for_file: file_names

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo/0_screens/2_important_screen.dart';
import 'package:todo/0_screens/3_scheduled_screen.dart';
import 'package:todo/0_screens/6_todo_screen.dart';
import 'package:todo/0_screens/7_custom_list_screen.dart';
import 'package:todo/0_screens/inhereted_widget.dart';

import 'package:todo/cubit/to_do_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo/data/database.dart';
import 'package:todo/0_screens/1_today_screen.dart';
import 'package:todo/data/provider.dart';

import 'package:todo/models/list_model.dart';

import '../models/todo_model.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

bool themeValue = false;
String todayLenght = "";
String importantLenght = "";
String scheduledLenght = "";
String toDosLenght = "";
Icon? icon;

class _TodoHomePageState extends State<TodoHomePage> {
  UserDatabaseProvider userDatabaseProvider = UserDatabaseProvider();
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    userDatabaseProvider.initialize().then((value) {
      // context.read<ToDoCubit>().fetchDataFromDatabase("");
      getAllScreensLengths();
      Provider.of<ToDoProvider>(context, listen: false)
          .fetchListsDataFromDatabase();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          resizeToAvoidBottomInset: false,
          floatingActionButton: IconButton(
            onPressed: () {
              showDialogMethod(context, provider);
            },
            icon: const Icon(
              Icons.add_card,
              size: 27,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              IconButton(
                  onPressed: () {
                    userDatabaseProvider.deleteall;
                    setState(() {
                      themeValue = !themeValue;
                    });
                  },
                  icon: const Icon(Icons.search))
            ],
            title: const Text('ToDo'),
          ),
          body: TryWidget(
            rrr: Colors.amber,
            child: Builder(builder: (context) {
              return BlocBuilder<ToDoCubit, List<ToDoModel>>(
                builder: (context, toDoList) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.sunny,
                          color: Color.fromARGB(255, 244, 108, 54),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TodayScreen(),
                            )).then((value) {
                          getAllScreensLengths();
                        }),
                        trailing: Text(todayLenght),
                        title: Text(AppLocalizations.of(context)!.listTile1),
                      ),
                      ListTile(
                        leading: Stack(
                          children: [
                            Positioned(
                              left: 4,
                              top: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Colors.yellow,
                                ),
                                height: 16,
                                width: 16,
                              ),
                            ),
                            const Icon(
                              Icons.stars,
                              color: Colors.black,
                            )
                          ],
                        ),
                        title: Text(AppLocalizations.of(context)!.listTile2),
                        trailing: Text(importantLenght),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImportantScreen(),
                            )).then((value) {
                          getAllScreensLengths();
                        }),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.date_range,
                          color: Color.fromARGB(255, 95, 168, 97),
                        ),
                        title: Text(AppLocalizations.of(context)!.listTile3),
                        trailing: Text(scheduledLenght),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScheduleScreen(),
                            )).then((value) {
                          getAllScreensLengths();
                        }),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.fact_check_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(AppLocalizations.of(context)!.listTile6),
                        trailing: Text(toDosLenght),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ToDoScreen(),
                            )).then((value) {
                          getAllScreensLengths();
                        }),
                      ),
                      const Divider(),
                      Expanded(
                        child: Consumer<ToDoProvider>(
                          builder: (context, provider, child) {
                            return SingleChildScrollView(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: provider.getlistOfList.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (direction) {
                                      print(provider.getlistOfList[0].id);

                                      provider.deleteListToList(
                                          provider.getlistOfList[index],
                                          provider
                                              .getlistOfList[index].listtitle);
                                    },
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => CustomScreen(
                                            customTableName: provider
                                                .getlistOfList[index].listtitle,
                                            backgroundColor: provider
                                                .getlistOfList[index]
                                                .customcolor,
                                            primaryColor: provider
                                                .getlistOfList[index]
                                                .primarycolor,
                                          ),
                                        ));
                                      },
                                      title: Text(provider
                                          .getlistOfList[index].listtitle),
                                      leading: provider
                                                  .getlistOfList[index].emoji ==
                                              "false"
                                          ? Icon(
                                              Icons.list,
                                              color: Color(provider
                                                  .getlistOfList[index]
                                                  .primarycolor),
                                            )
                                          : Text(
                                              provider
                                                  .getlistOfList[index].emoji,
                                              style:
                                                  const TextStyle(fontSize: 23),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  _pickIcon() async {
    IconData? icon =
        await showIconPicker(context, iconPackModes: [IconPack.cupertino]);

    icon = Icon(icon) as IconData?;
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  Future<dynamic> showDialogMethod(
      BuildContext context, ToDoProvider provider) {
    debugPrint("showDialog rebuidl");
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      builder: (context) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                constraints:
                    const BoxConstraints(maxHeight: 450, maxWidth: 350),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: provider.getisEmojiActive ? 350 : 275,
                    width: 280,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12, left: 12),
                              child: Text(
                                "Yeni Liste",
                                style: TextStyle(
                                    color: Color(
                                        provider.getnewListBackgroundColor),
                                    decoration: TextDecoration.none,
                                    fontSize: 15),
                              ),
                            ),
                            Row(
                              children: [
                                if (provider.getemoji != "false")
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: TextButton(
                                      style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          iconSize:
                                              MaterialStatePropertyAll(5)),
                                      onPressed: () {
                                        provider.changeEmojiActive(
                                            !provider.getisEmojiActive);
                                      },
                                      child: Text(
                                        provider.getemoji,
                                        style: const TextStyle(
                                            fontSize: 22, wordSpacing: 0),
                                      ),
                                    ),
                                  ),
                                if (provider.getemoji == "false")
                                  IconButton(
                                      onPressed: () {
                                        provider.changeEmojiActive(
                                            !provider.getisEmojiActive);
                                      },
                                      icon: Icon(
                                        Icons.face,
                                        color: provider.getisEmojiActive
                                            ? Colors.blue
                                            : Color(provider
                                                .getnewListBackgroundColor),
                                      )),
                                Expanded(
                                  child: SizedBox(
                                    width: 232,
                                    height: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0, top: 8, right: 8, left: 8),
                                      child: Material(
                                          color: Colors.transparent,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.length < 3) {
                                                return "Cant be less than 3 character";
                                              }
                                              return null;
                                            },
                                            controller: _controller,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Listenize başlık ekleyin"),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (provider.getisEmojiActive)
                              Stack(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: EmojiPicker(
                                      onEmojiSelected: (category, emoji) {
                                        provider.changeEmojiString(emoji.emoji);
                                      },
                                      onBackspacePressed: () {
                                        // Do something when the user taps the backspace button (optional)
                                        // Set it to null to hide the Backspace-Button
                                      },
                                      config: const Config(
                                        height: 240,
                                        checkPlatformCompatibility: true,
                                        emojiViewConfig: EmojiViewConfig(
                                          backgroundColor: Colors.transparent,
                                          // Issue: https://github.com/flutter/flutter/issues/28894
                                          emojiSizeMax: 18,
                                        ),
                                        swapCategoryAndBottomBar: false,
                                        skinToneConfig: SkinToneConfig(),
                                        categoryViewConfig: CategoryViewConfig(
                                            backgroundColor:
                                                Colors.transparent),
                                        bottomActionBarConfig:
                                            BottomActionBarConfig(
                                          enabled: true,
                                          showBackspaceButton: false,
                                          /* customBottomActionBar: (config, state, showSearchView) {
                                            return const Text("data");
                                          }, */
                                        ),
                                        searchViewConfig: SearchViewConfig(
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            style: const ButtonStyle(),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              provider
                                                  .changeNewListBackgroundColor(
                                                      0xFF000000);
                                            },
                                            child: const Text("Cancel")),
                                        ElevatedButton(
                                            onPressed: () {
                                              submitNewList(context, provider);
                                            },
                                            child: const Text("Confirm")),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            if (!provider.getisEmojiActive)
                              Column(children: [
                                const MyToggleButtons(),
                                const SizedBox(
                                  height: 22,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        style: const ButtonStyle(),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          provider.changeNewListBackgroundColor(
                                              0xFF000000);
                                        },
                                        child: const Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () {
                                          submitNewList(context, provider);
                                        },
                                        child: const Text("Confirm")),
                                  ],
                                ),
                              ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void submitNewList(BuildContext context, ToDoProvider provider) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ListModel newListModel = ListModel(
          listtitle: _controller.text,
          customcolor: provider.getnewListBackgroundColor,
          primarycolor: provider.getnewListPrimaryColor,
          emoji: provider.getemoji);

      Provider.of<ToDoProvider>(context, listen: false)
          .addListToList(newListModel);

      userDatabaseProvider.createTable(_controller.text);
      _controller.text = "";

      /* userDatabaseProvider.getListid().then((value) {
             int aa = value;
             print(aa);
          }); */
      Navigator.pop(context);
      Future.delayed(const Duration(seconds: 1),
          () => provider.changeEmojiString("false"));
    }
  }

  void getAllScreensLengths() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        userDatabaseProvider.getTodayListLength("ToDo").then((lenght) {
          todayLenght = lenght;
        });
        userDatabaseProvider.getImportantListLength("ToDo").then((lenght) {
          importantLenght = lenght;
        });
        userDatabaseProvider.getScheduledListLength("ToDo").then((lenght) {
          scheduledLenght = lenght;
        });
        userDatabaseProvider.getAllListLength("ToDo").then((lenght) {
          toDosLenght = lenght;
        });
      });
    });
  }
}

class MyToggleButtons extends StatefulWidget {
  const MyToggleButtons({super.key});

  @override
  MyToggleButtonsState createState() => MyToggleButtonsState();
}

class MyToggleButtonsState extends State<MyToggleButtons> {
  List<bool> isSelected = [true, false];
  int chosenindex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              borderColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.amber,
              highlightColor: Colors.amber,
              selectedBorderColor: Colors.transparent,
              fillColor: Colors.transparent,
              selectedColor: Color(provider.getnewListBackgroundColor),
              isSelected: isSelected,
              onPressed: (index) {
                chosenindex = index;
                setState(() {
                  if (index == 0) {
                    isSelected[0] = true;
                    isSelected[1] = false;
                  } else {
                    isSelected[1] = true;
                    isSelected[0] = false;
                  }
                });
              },
              children: const <Widget>[
                Text(
                  "Renk",
                ),
                Text("Fotoğraf")
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: senRowBack(chosenindex, provider),
              ),
            )
          ],
        );
      },
    );
  }

  senRowBack(int tappedButton, ToDoProvider provider) {
    if (tappedButton == 0) {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              provider.changeNewListBackgroundColor(0xFFFF9640);
              provider.changeNewListPrimaryColor(0xFFD35F00);
            },
            child: const CircleAvatar(
                backgroundColor: Color.fromRGBO(255, 150, 64, 1)),
          ),
          const SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: () {
              provider.changeNewListBackgroundColor(0xFFFF4C4C);
              provider.changeNewListPrimaryColor(0xFFC10000);
            },
            child: const CircleAvatar(
              backgroundColor: Color.fromRGBO(193, 0, 0, 1),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: () {
              provider.changeNewListBackgroundColor(0xFF1F1F1F);
              provider.changeNewListPrimaryColor(0xFF080808);
            },
            child: const CircleAvatar(
              backgroundColor: Color.fromRGBO(31, 31, 31, 1),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: () {
              provider.changeNewListBackgroundColor(0xFF4CAF50);
              provider.changeNewListPrimaryColor(0xFF398300);
            },
            child: const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 76, 175, 80),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: () {
              provider.changeNewListBackgroundColor(0xFF2EA1FF);
              provider.changeNewListPrimaryColor(0xFF006FCA);
            },
            child: const CircleAvatar(
                backgroundColor: Color.fromRGBO(0, 111, 202, 1)),
          ),
          const SizedBox(
            width: 3,
          ),
          GestureDetector(
            onTap: () {
              provider.changeNewListBackgroundColor(0xFFA13DB3);
              provider.changeNewListPrimaryColor(0xFF800496);
            },
            child: const CircleAvatar(
                backgroundColor: Color.fromRGBO(140, 6, 163, 1)),
          ),
        ],
      );
    } else if (tappedButton == 1) {
      return const Row(
        children: [
          CircleAvatar(),
          CircleAvatar(),
          CircleAvatar(),
          CircleAvatar(),
          CircleAvatar(),
          CircleAvatar(),
          CircleAvatar()
        ],
      );
    }
  }
}
