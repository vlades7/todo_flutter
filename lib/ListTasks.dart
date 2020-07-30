import 'package:flutter/material.dart';

class ListTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  final title = 'Список задач';
  static const DARK_RED_COLOR = Color(0xffcf0000);

  static int _counter = 1;
  final List<String> _tasks = <String>[];
  final Set<String> _completedTasks = Set<String>();

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTasks(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: ButtonBar(
        buttonMinWidth: MediaQuery.of(context).size.width / 2 - 12,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildButton('Удалить всё', Colors.red, () => _deleteAll()),
          _buildButton('Выполнить всё', Colors.green, () => _checkAll()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_tasks.isEmpty) {
      return _buildInit();
    } else {
      return Scrollbar(child: _buildTasks());
    }
  }
  
  Widget _buildInit() {
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        child: Align(
          child: Text(
            'Задачи отсутствуют',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasks() {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      controller: _scrollController,
      itemCount: _tasks.length,
      itemBuilder: (context, index) => Container(
        height: 50,
        child: Center(child: _buildRow(_tasks[index])),
      ),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildRow(String task) {
    final checked = _completedTasks.contains(task);

    return ListTile(
      title: Text(task,
          style: checked
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : const TextStyle(decoration: TextDecoration.none)),
      leading: IconButton(
          icon: Icon(checked ? Icons.check_box : Icons.check_box_outline_blank),
          onPressed: () => _checkTask(checked, task),
          color: checked ? Colors.green : null),
      trailing: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => _deleteTask(task),
        color: DARK_RED_COLOR,
      ),
    );
  }

  Widget _buildButton(String text, MaterialColor color, Function func) {
    return RaisedButton(
      child: Text(text),
      color: color,
      splashColor: color[300],
      onPressed: () => func(),
    );
  }

  void _createTasks() {
    _tasks.add("Задача №$_counter");
    _incrementCounter();
    _scrollBottom();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _deleteTask(String task) {
    setState(() {
      _completedTasks.remove(task);
      _tasks.remove(task);
    });
  }

  void _checkTask(bool checked, String task) {
    setState(() {
      if (!checked) {
        _completedTasks.add(task);
      } else {
        _completedTasks.remove(task);
      }
    });
  }

  void _deleteAll() {
    setState(() {
      _tasks.clear();
      _completedTasks.clear();
    });
  }

  void _checkAll() {
    setState(() {
      _tasks.forEach(_completedTasks.add);
    });
  }

  void _scrollBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
  }
}
