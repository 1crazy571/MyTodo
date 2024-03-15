/* part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class FetchTodos extends TodosEvent {}

class FilterTodosByCategory extends TodosEvent {
  final String category;

  const FilterTodosByCategory(this.category);

  @override
  List<Object> get props => [category];
} */