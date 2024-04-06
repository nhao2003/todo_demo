const TodoService = require("../services/todo.service");

class TodoController {
  constructor() {
    this.todoService = new TodoService();
  }

  async getAllTodos(req, res) {
    try {
      await this.todoService.connect();
      const sortBy = req.query.sortBy;
      const todos = await this.todoService.getAllTodos(sortBy);
      res.json(todos);
    } catch (err) {
      console.error("Error:", err.message);
      res.status(500).json({ error: err.message });
    }
  }

  async getTodoById(req, res) {
    try {
      await this.todoService.connect();
      const id = req.params.id;
      const todo = await this.todoService.getTodoById(id);
      if (!todo) {
        return res.status(404).json({ error: "Todo not found" });
      }
      res.json(todo);
    } catch (err) {
      console.error("Error:", err.message);
      res.status(500).json({ error: err.message });
    }
  }

  async createTodo(req, res) {
    try {
      await this.todoService.connect();
      const todo = req.body;
      const createdTodo = await this.todoService.createTodo(todo);
      res.status(201).json(createdTodo);
    } catch (err) {
      console.error("Error:", err.message);
      res.status(500).json({ error: err.message });
    }
  }

  async updateTodo(req, res) {
    try {
      await this.todoService.connect();
      const id = req.params.id;
      const updatedTodo = req.body;
      const result = await this.todoService.updateTodo(id, updatedTodo);
      res.json(result);
    } catch (err) {
      console.error("Error:", err.message);
      res.status(500).json({ error: err.message });
    }
  }

  async deleteTodo(req, res) {
    try {
      await this.todoService.connect();
      const id = req.params.id;
      const result = await this.todoService.deleteTodo(id);
      res.json(result);
    } catch (err) {
      console.error("Error:", err.message);
      res.status(500).json({ error: err.message });
    }
  }
}

module.exports = TodoController;
