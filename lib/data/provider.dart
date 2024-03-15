import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:todo/data/database.dart';
import 'package:todo/models/list_model.dart';
import 'package:todo/models/todo_model.dart';

class ToDoProvider extends ChangeNotifier {
  String _toDoTitle = '',
      _toDoText = '',
      _toDoDate = '',
      _toDoisDone = 'false',
      _toDoTime = '';

  String _toDoImportant = "false";
  String _toDoisToday = "false";
  String _emoji = "false";
  RenderBox? renderbox;
  List<ListModel> _listOfList = [];

  final int _toDoid = 0;
  bool _ischip1selected = false;
  bool _bottomAddWidget = false;
  bool _isEmojiActive = false;


  bool _ischip2selected = false;
  int _newListBackgroundColor = 0xFF1F1F1F;
  int _newListPrimaryColor = 0xFF080808;
  DateTime _schedule = DateTime.now();
  DateTime _cacheSchedule = DateTime.now();

  bool get getischip1selected => _ischip1selected;
  bool get getisEmojiActive => _isEmojiActive;
  bool get getbottomAddWidget => _bottomAddWidget;
  int get getnewListBackgroundColor => _newListBackgroundColor;
  int get getnewListPrimaryColor => _newListPrimaryColor;
  List<ListModel> get getlistOfList => _listOfList;
  bool get getischip2selected => _ischip2selected;
  RenderBox? get getRenderBox => renderbox;

  String get getImportant => _toDoImportant;
  String get getemoji => _emoji;
  String get gettoDoisToday => _toDoImportant;
  String get gettoDoTitle => _toDoTitle;
  String get gettoDoisDone => _toDoisDone;
  int get gettoDoid => _toDoid;

  String get gettoDoText => _toDoText;
  DateTime get getschedule => _schedule;
  DateTime get getcacheSchedule => _cacheSchedule;
  String get gettoDoDate => _toDoDate;

  String get gettoDoTime => _toDoTime;

  void changeRenderBox(RenderBox gelenRenderBox) {
    renderbox = gelenRenderBox;
  }

  void fetchListsDataFromDatabase() {
    UserDatabaseProvider database = UserDatabaseProvider();

    database.getList().then((value) {
      _listOfList = value;
    });
    notifyListeners();
  }

  void addListToList(ListModel gelenModel) {
    UserDatabaseProvider database = UserDatabaseProvider();
    database.insertList(gelenModel);
    database.getList().then((value) {
      _listOfList = value;
      notifyListeners();
    });
  }

  void changeEmojiString (String emoji){
    _emoji = emoji;
    notifyListeners();
  }

  void changeNewListBackgroundColor(int gelenColor) {
    _newListBackgroundColor = gelenColor;
    notifyListeners();
  }

  void changeNewListPrimaryColor(int gelenColor) {
    _newListPrimaryColor = gelenColor;
    notifyListeners();
  }

  void deleteListToList(ListModel gelenModel, String title) {
    UserDatabaseProvider database = UserDatabaseProvider();
    database.deleteTable(title);

    database.delete(gelenModel.id!, "Lists");
    _listOfList.remove(gelenModel);

    notifyListeners();
  }

  void changeChip1(bool newChip1) {
    _ischip1selected = newChip1;
    notifyListeners();
  }

  void changeEmojiActive(bool gelenbool) {
    _isEmojiActive = gelenbool;
    notifyListeners();
  }

  

  void changeBottomWidget(bool bool) {
    _bottomAddWidget = bool;
    notifyListeners();
  }

  void changeChip2(bool newChip2) {
    _ischip2selected = newChip2;
    notifyListeners();
  }

  void changetoDoTitle(String value) {
    _toDoTitle = value;
  }

  void changetoDoText(String value) {
    _toDoText = value;
    notifyListeners();
  }

  void changetoDoDate(String value) {
    _toDoDate = value;

    notifyListeners();
  }

  void changetoDoTime(String value) {
    _toDoTime = value;
    notifyListeners();
  }

  void changetoDoImportant(String value) {
    _toDoImportant = value;
    notifyListeners();
  }

  void changetoDoisToday(String value) {
    _toDoisToday = value;
    notifyListeners();
  }

  void changetoDoisDone(String value) {
    _toDoisDone = value;
    notifyListeners();
  }

  void changeScheduleDate(DateTime value) {
    _schedule = DateTime(value.year, value.month, value.day);
    notifyListeners();
  }

  void changeScheduleTime(DateTime value) {
    _schedule = DateTime(_schedule.year, _schedule.month, _schedule.day,
        value.hour, value.minute);
    notifyListeners();
  }

  void changeCacheDate(DateTime value) {
    _cacheSchedule = DateTime(value.year, value.month, value.day);
    notifyListeners();
  }

  void changeCacheTime(Time value) {
    _cacheSchedule = DateTime(_cacheSchedule.year, _cacheSchedule.month,
        _cacheSchedule.day, value.hour, value.minute);
    notifyListeners();
  }

  void deletecache() {
    _toDoTitle = '';
    _toDoText = '';
    _toDoDate = '';
    _toDoTime = '';
    notifyListeners();
  }

  ToDoModel getToDo() {
    return ToDoModel(
        isdone: _toDoisDone,
        title: _toDoTitle,
        text: _toDoText,
        createdAt: DateTime.now().toString(),
        schedule: '$_toDoDate$_toDoTime',
        isimportant: _toDoImportant,
        istoday: _toDoisToday);
  }
}
