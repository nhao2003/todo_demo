const { MongoClient, ObjectId } = require("mongodb");

class TodoService {
  constructor() {
    this.mongoURI = "mongodb://localhost:27017";
    this.dbName = "todoDB";
    this.collectionName = "todos";
  }

  async connect() {
    try {
      const client = await MongoClient.connect(this.mongoURI, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      });
      this.db = client.db(this.dbName);
      this.collection = this.db.collection(this.collectionName);
      console.log("Connected to MongoDB");
    } catch (err) {
      console.error("Error connecting to MongoDB:", err);
    }
  }

  async getAllTodos() {
    try {
      return await this.collection.find().toArray();
    } catch (err) {
      console.error("Error fetching todos:", err);
      throw new Error("Failed to fetch todos");
    }
  }

  async getTodoById(id) {
    try {
      console.log(id);
      const data = await this.collection.findOne({ _id: new ObjectId(id) });

      console.log(data);
      return data;
    } catch (err) {
      console.error("Error fetching todo:", err);
      throw new Error("Failed to fetch todo");
    }
  }

  async createTodo(todo) {
    try {
      const result = await this.collection.insertOne({
        ...todo,
        done: false,
        createdAt: new Date(),
      });
      return result.insertedId;
    } catch (err) {
      console.error("Error creating todo:", err);
      throw new Error("Failed to create todo");
    }
  }

  async updateTodo(id, updatedTodo) {
    try {
      delete updatedTodo._id;
      const result = await this.collection.updateOne(
        { _id: new ObjectId(id) },
        { $set: updatedTodo }
      );
      if (result.modifiedCount === 0) {
        throw new Error("Todo not found");
      }
      return { message: "Todo updated successfully" };
    } catch (err) {
      console.error("Error updating todo:", err);
      throw new Error("Failed to update todo");
    }
  }

  async deleteTodo(id) {
    try {
      const result = await this.collection.deleteOne({ _id: new ObjectId(id) });
      if (result.deletedCount === 0) {
        throw new Error("Todo not found");
      }
      return { message: "Todo deleted successfully" };
    } catch (err) {
      console.error("Error deleting todo:", err);
      throw new Error("Failed to delete todo");
    }
  }
}

module.exports = TodoService;
