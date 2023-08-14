import 'package:databasa_test_1/app_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        title: 'DataBase',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  String title;
  HomePage({required this.title});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDataBase myDB;
  List<Map<String, dynamic>> arrNotes = [];

  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  initState() {
    super.initState();
    myDB = AppDataBase.db;

    getNotes();
  }

  void getNotes() async {
    arrNotes = await myDB.fetchAllNotes();
  }

  void addNotes(String title ,String desc) async {
    bool check = await myDB.addNote(title, desc);
    if (check) {
      arrNotes = await myDB.fetchAllNotes();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),
      ),
      body: ListView.builder(
          itemCount: arrNotes.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text('${arrNotes[index]['title']}'),
              subtitle: Text('${arrNotes[index]['desc']}'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 400,
                  child: Column(
                    children: [
                      Text(
                        'Add',
                        style: TextStyle(fontSize: 21),
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: 'Enter Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21.0),
                            )),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                            hintText: 'Enter Desc',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21.0),
                            )),
                      ),
                      ElevatedButton(child: Text('Add'),
                      onPressed: (){
                         var title = titleController.text.toString();
                         var desc = descController.text.toString();

                         addNotes(title,desc);
                      }
                      )
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
