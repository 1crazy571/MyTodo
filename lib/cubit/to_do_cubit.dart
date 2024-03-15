import 'package:awesome_notifications/awesome_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:todo/data/database.dart';
import 'package:todo/models/todo_model.dart';
part 'to_do_state.dart';

class ToDoCubit extends Cubit<List<ToDoModel>> {
  ToDoCubit() : super([]);

  void fetchDataFromDatabase(String tableName) {
    print("fetchDataFromDatabase");
    UserDatabaseProvider database = UserDatabaseProvider();
    print(tableName);
    database.getListOfModel(tableName).then((value) {
      var yyooo = value;
      emit(yyooo);
    });
  }

  Future<List<ToDoModel>> fetchListForNotification(String tableName) async {
    UserDatabaseProvider database = UserDatabaseProvider();

    var list = await database.getListOfModel(tableName);
    return list;
  }

  void fetchDataFromDatabaseScheduled(String tableName) {
    print("fetchDataFromDatabaseScheduled");
    UserDatabaseProvider database = UserDatabaseProvider();

    database.getListScheduled(tableName).then((value) {
      var state = value;
      emit([...state]);
    });
  }

  void fetchDataFromDatabaseImportant(String tableName) {
    print("fetchDataFromDatabaseImportant");
    UserDatabaseProvider database = UserDatabaseProvider();

    database.getListImportant(tableName).then((value) {
      var state = value;
      emit([...state]);
    });
  }

  void fetchDataFromDatabaseIsToday(String tableName) {
    print("fetchDataFromDatabaseIsToday");
    UserDatabaseProvider database = UserDatabaseProvider();

    database.getListToday(tableName).then((value) {
      var state = value;
      emit([...state]);
    });
  }

  Future<int> submitToDo(ToDoModel toDoModel, String tableName) async {
    UserDatabaseProvider database = UserDatabaseProvider();
    int id = await database.insert(toDoModel, tableName);
    emit([...state]);
    return id;
  }

  void changeToDo(
      List<ToDoModel> toDoList, ToDoModel newToDo, String tableName) {
    UserDatabaseProvider database = UserDatabaseProvider();
    database.changeToDo(newToDo.id!, newToDo, tableName);
    emit([...state]);
  }

  void removeToDo(List<ToDoModel> toDoList, ToDoModel silinecekToDo) {
    toDoList.remove(silinecekToDo);
    emit([...toDoList]);
  }

  void removeToDoNotification(ReceivedNotification receivedNotification) async {
    Map<String, String?>? payload = receivedNotification.payload;
    List<ToDoModel> myToDoList =
        await fetchListForNotification(payload!["tablename"]!);

    UserDatabaseProvider database = UserDatabaseProvider();
    ToDoModel toDoModel = myToDoList
        .firstWhere((element) => element.id == receivedNotification.id);
    int index = myToDoList
        .indexWhere((element) => element.id == receivedNotification.id);
    var newToDoModel = toDoModel.copyWith(schedule: "");
    myToDoList[index] = newToDoModel;
    database.changeToDo(
        newToDoModel.id!, newToDoModel, newToDoModel.tablename!);
    emit([...myToDoList]);
  }
}
