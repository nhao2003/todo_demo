import 'package:flutter/material.dart';

import 'models/todo.dart';

class TodoPopupResult {
  final Todo todo;
  final bool isNew;

  TodoPopupResult({required this.todo, this.isNew = false});
}

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;
  const AddEditTodoScreen({super.key, this.todo}) : super();

  @override
  State<StatefulWidget> createState() {
    return _AddEditTodoScreenState();
  }
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _done = widget.todo!.done;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        actions: <Widget>[
          // OutlineButton(
          TextButton(
            onPressed: () {
              final Todo todo = Todo(
                id: widget.todo?.id ?? '',
                title: _titleController.text,
                description: _descriptionController.text,
                done: _done,
                createdAt: DateTime.now(),
              );
              Navigator.of(context).pop<TodoPopupResult>(
                  TodoPopupResult(todo: todo, isNew: widget.todo == null));
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 10,
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Done'),
                value: _done,
                onChanged: (bool? value) {
                  setState(() {
                    _done = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
