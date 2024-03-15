part of 'to_do_cubit.dart';

@immutable
sealed class ToDoState {}

final class ToDoInitial extends ToDoState {}

final class ToDoSuccess extends ToDoState {
  final ToDoModel toDoModel;

  ToDoSuccess({required this.toDoModel});
}

final class ToDoFailure extends ToDoState {
  final String error;

  ToDoFailure(this.error);
}

final class ToDoLoading extends ToDoState {}