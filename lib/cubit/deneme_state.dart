/* part of 'todos_bloc.dart';




abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<ToDoModel> todos;

  const TodosLoaded({required this.todos});

  @override
  List<Object> get props => [todos];
}

class TodosFiltered extends TodosState {
  final List<ToDoModel> filteredTodos;
  final String category;

  const TodosFiltered({required this.filteredTodos, required this.category});

  @override
  List<Object> get props => [filteredTodos, category];
}

class TodosError extends TodosState {
  final String message;

  const TodosError(this.message);

  @override
  List<Object> get props => [message];
} */