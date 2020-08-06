import 'package:flutter/material.dart';

class ListTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  final title = 'Список задач';
  static const DARK_RED_COLOR = Color(0xffcf0000);

  Set<String> _tasks = Set<String>();
  Set<String> _completedTasks = Set<String>();

  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            onPressed: () => {_createTask()},
          )
        ],
      ),
      body: _buildBody(),
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
        child: Center(child: _buildRow(_tasks.toList()[index])),
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

  void _createTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить задачу:'),
          content: TextField(
            controller: _textEditingController,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Отменить'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Добавить'),
              onPressed: () => _addTask(),
            ),
          ],
        );
      },
    );
  }

  void _addTask() {
    String task = _textEditingController.value.text;
    if (task != "") {
      _tasks.add(task);
    }
    _textEditingController.clear();
    Navigator.of(context).pop();
    _scrollBottom();
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
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear);
    }
  }
}