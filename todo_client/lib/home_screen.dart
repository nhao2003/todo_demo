import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_client/todo_repository.dart';
import 'models/todo.dart';
import 'todo_pop_up.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoRepository _todoRepository = TodoRepository();
  void _addTodo(Todo todo) {
    setState(() {
      _todoRepository.addTodo(todo);
    });
  }

  Future<void> openAddTodoPopup(Todo? todo) async {
    final result = await Navigator.push<TodoPopupResult>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTodoScreen(
          todo: todo,
        ),
      ),
    );

    if (result != null) {
      if (result.isNew) {
        _addTodo(result.todo);
      } else {
        await _todoRepository.updateTodo(result.todo);
      }
      setState(() {});
    }
  }

  final List<Todo> todos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Todo List'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: FutureBuilder<List<Todo>>(
          future: _todoRepository.fetchTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            todos.clear();
            todos.addAll(snapshot.data!);
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = snapshot.data![index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _todoRepository.deleteTodo(todo);
                          setState(() {});
                        },
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: Checkbox(
                      value: todo.done,
                      onChanged: (bool? value) async {
                        todo.done = value!;
                        await _todoRepository.updateTodo(todo);
                        setState(() {});
                      },
                    ),
                    onTap: () async {
                      await openAddTodoPopup(todo);
                    },
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await openAddTodoPopup(null);
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}
