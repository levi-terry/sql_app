import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQL Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'SQL Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Database database;
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  Future<void> _addToDatabase() async {
    final Database db = database;
    Map<String, String> values = {
      "type": _typeController.text,
      "serial": _serialController.text,
    };
    await db.insert("test", values);
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'test_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE test(type TEXT, serial TEXT PRIMARY KEY)',
        );
      },
      version: 1,
    );
  }

  @override
  void initState() {
    _initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextRow(
                  textController: _serialController,
                  name: "Serial",
                ),
                TextRow(
                  textController: _typeController,
                  name: "Type",
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: _addToDatabase,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _serialController.dispose();
    super.dispose();
  }
}

class TextRow extends StatelessWidget {
  const TextRow({
    Key? key,
    required TextEditingController textController,
    required String name,
  })  : _textController = textController,
        _name = name,
        super(key: key);

  final TextEditingController _textController;
  final String _name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(_name),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: _textController,
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}

class DataObject {}
