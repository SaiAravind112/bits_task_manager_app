import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'raqgvgwPBk5DncJRfuPvofFrT51jNMRfXwextHyu',
    'https://parseapi.back4app.com',
    clientKey: 'Wvr6mf6XV8bkmmTuR093UN5FDUxiiQM8H36JaINx',
    autoSendSessionId: true,
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page new'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Task {
  final String title;
  final String description;
  final String objectId;
  final String dueDate;
  final String category;

  Task({required this.objectId, required this.title, required this.description,required this.dueDate, required this.category,});
}

class TaskList extends StatelessWidget {
  // const TaskList({super.key});
  final List<Task> tasks;
  final Function refreshCallback;

  TaskList({required this.tasks, required this.refreshCallback});

//   @override
//   _TaskListState createState() => _TaskListState();
// }
//
// class _TaskListState extends State<TaskList> {
//   List<Task> tasks = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTasks();
//   }
//
//   Future<void> refreshCallback() async {
//     await _fetchTasks();
//   }
//
//   Future<void> _fetchTasks() async {
//     final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'));
//     final response = await queryBuilder.query();
//
//     if (response.success && response.results != null) {
//       final taskList = response.results!.map((result) {
//         return Task(
//           title: result.get<String>('title') ?? '',
//           description: result.get<String>('description') ?? '',
//           objectId: result.get<String>('objectId') ?? '',
//         );
//       }).toList();
//
//       setState(() {
//         tasks = taskList;
//       });
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItem(task: task, refreshCallback: refreshCallback);
      },
    );
  }
}

Widget _buildCategoryTag(String category) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.deepOrangeAccent, // You can change the color to your preference
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      category,
      style: TextStyle(color: Colors.white),
    ),
  );
}

Widget _buildDueDateTag(String category) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.indigoAccent, // You can change the color to your preference
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      category,
      style: TextStyle(color: Colors.white),
    ),
  );
}

class TaskItem extends StatelessWidget {
  final Task task;
  final Function refreshCallback;

  TaskItem({super.key, required this.task, required this.refreshCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}'),
            Text('Due Date: ${task.dueDate}'), // Display due date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Due Date:'),
                    const SizedBox(width: 4),
                    _buildDueDateTag(task.dueDate),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Category:'),
                    const SizedBox(width: 4), // Add spacing between "Category" and the tag
                    _buildCategoryTag(task.category), // Display category as a tag
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(context, task);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                taskId: task.objectId,
                currentTitle: task.title,
                currentDescription: task.description,
                currentDueDate: task.dueDate,
                currentCategory: task.category,
              ),
            ),
          );
        },
      ),
    );
  }

  // Show a confirmation dialog for task deletion
  Future<void> _showDeleteConfirmationDialog(BuildContext context, Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // User confirmed the deletion
      _deleteTask(context, task);
    }
  }

  // Delete the task from Back4App
  void _deleteTask(BuildContext context, Task task) async {
    // Perform the deletion logic here using Back4App's SDK.
    // You can use similar logic as in the EditTaskScreen to delete the task.
    // After successful deletion, you can update the UI or show a success message.
    // On failure, show an error message.

    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('objectId', task.objectId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final task = response.results![0];
      final deleteResponse = await task.delete();

      if (deleteResponse.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Task deleted successfully!'),
        ));
        // Refresh the task list after successful deletion
        refreshCallback();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete task. Please try again.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task not found. Please try again.'),
      ));
    }

    // After deletion, you can refresh the task list, if needed.
  }
}



class NewTaskScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'), // Input field for due date
            ),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'), // Input field for category
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final newTitle = titleController.text;
                final newDescription = descriptionController.text;
                final newDueDate = dueDateController.text;
                final newCategory = categoryController.text;
                Navigator.of(context).pop({
                  'title': newTitle,
                  'description': newDescription,
                  'dueDate': newDueDate,
                  'category': newCategory,
                });
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}


class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String currentTitle;
  final String currentDescription;
  final String currentDueDate;
  final String currentCategory;

  EditTaskScreen({
    required this.taskId,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentDueDate,
    required this.currentCategory,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currentTitle);
    descriptionController = TextEditingController(text: widget.currentDescription);
    dueDateController = TextEditingController(text: widget.currentDueDate);
    categoryController = TextEditingController(text: widget.currentCategory);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: dueDateController,
              decoration: const InputDecoration(labelText: 'Due Date'),
            ),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async{
                final newTitle = titleController.text;
                final newDescription = descriptionController.text;
                final newDueDate = dueDateController.text;
                final newCategory = categoryController.text;
                await updateTask(widget.taskId, newTitle, newDescription, newDueDate, newCategory);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateTask(String taskId, String newTitle, String newDescription, String newDueDate, String newCategory) async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('objectId', taskId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final task = response.results![0];
      task.set<String>('title', newTitle);
      task.set<String>('description', newDescription);
      task.set<String>('dueDate', newDueDate);
      task.set<String>('category', newCategory);

      final updateResponse = await task.save();

      if (updateResponse.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Task updated successfully!'),
        ));
        Navigator.pop(context); // Return to TaskDetailsScreen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update task. Please try again.'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task not found. Please try again.'),
      ));
    }
  }
}


Future<void> createAndSaveTask(BuildContext context, String title, String description, String dueDate, String category) async {
  final newTask = ParseObject('Task')
    ..set<String>('title', title)
    ..set<String>('description', description)
    ..set<String>('dueDate', dueDate) // Set due date
    ..set<String>('category', category); // Set category

  final response = await newTask.save();

  if (response.success) {
    // Task saved successfully, update the UI or show a success message.
    // For example, show a SnackBar with a success message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task saved successfully.'),
        duration: Duration(seconds: 2),
      ),
    );
  } else {
    // Task save failed, handle the error or show an error message.
    // Task save failed, handle the error or show an error message.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task save failed: ${response.error!.message}'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}



class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _refreshTaskList();
  }

  void _refreshTaskList() async {
    await _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject('Task'))..orderByAscending('createdAt');
    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      final taskList = response.results!.map((result) {
        return Task(
          title: result.get<String>('title') ?? '',
          description: result.get<String>('description') ?? '',
          objectId: result.get<String>('objectId') ?? '',
          dueDate: result.get<String>('dueDate') ?? '',
          category: result.get<String>('category') ?? '',
        );
      }).toList();

      setState(() {
        tasks = taskList;
      });
    }
  }


  void _createAndSaveTask() async {
    BuildContext currentContext = context; // Store the context
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTaskScreen()),
    );

    if (result != null) {
      final newTitle = result['title'];
      final newDescription = result['description'];
      final newDueDate = result['dueDate']; // Get the due date
      final newCategory = result['category']; // Get the category
      await createAndSaveTask(context, newTitle, newDescription, newDueDate, newCategory);
      _refreshTaskList();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20.0, // Increase the title text size
            fontWeight: FontWeight.bold, // Make the text bold
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.white, // Add a blue shadow
                offset: Offset(2, 2), // Offset for a 3D effect
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: TaskList(tasks: tasks, refreshCallback: _refreshTaskList,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Ensure the button is properly placed
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              onPressed: _refreshTaskList,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor, // Button background color
              ),
              label: const Text('Refresh Tasks', style: TextStyle(color:  Colors.teal, fontWeight: FontWeight.bold, fontSize: 13),),
            ),
            ElevatedButton.icon(
              onPressed: _createAndSaveTask,
              icon: Icon(Icons.add),
              label: const Text('Add New Task', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 13),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor, // Button background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
