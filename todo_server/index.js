const express = require('express');
const bodyParser = require('body-parser');
const TodoController = require('./src/controllers/todo.controller');
const app = express();
const PORT = process.env.PORT || 3000;
const { body } = require('express-validator');
// cors
const cors = require('cors');

app.use(cors());
app.use(bodyParser.json());

const todoController = new TodoController();

const validateTodo = [
    body('title').isString().isLength({ min: 1 }),
    body('description').isString().isLength({ min: 1 }),
    body('done').isBoolean(),
    body('priority').isString().isIn(['low', 'medium', 'high']),
    body('time').isString().isISO8601(),
    ];
    

app.get('/todos', todoController.getAllTodos.bind(todoController));
app.get('/todos/:id', todoController.getTodoById.bind(todoController));
app.post('/todos', validateTodo, todoController.createTodo.bind(todoController));
app.put('/todos/:id', validateTodo, todoController.updateTodo.bind(todoController));
app.delete('/todos/:id', todoController.deleteTodo.bind(todoController));

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
