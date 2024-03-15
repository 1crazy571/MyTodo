/* 
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo_model.dart';

part 'deneme_event.dart';
part 'deneme_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoRepository todoRepository;

  TodosBloc({required this.todoRepository}) : super(TodosInitial()) {
    on<FetchTodos>((event, emit) async {
      emit(TodosLoading());
      try {
        final todos = await todoRepository.fetchTodos();
        emit(TodosLoaded(todos: todos));
      } catch (e) {
        emit(TodosError(e.toString()));
      }
    });

    on<FilterTodosByCategory>((event, emit) {
      if (state is TodosLoaded) {
        final filteredTodos = (state as TodosLoaded)
            .todos
            .where((todo) => todo.category == event.category)
            .toList();
        emit(TodosFiltered(filteredTodos: filteredTodos, category: event.category));
      }
    });
  }
}

 */