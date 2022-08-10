import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite6_7/connection/database_connection.dart';
import 'package:sqlite6_7/models/person_model.dart';
import 'package:sqlite6_7/update_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // primarySwatch: Colors.yellow,
          ),
      home: const MyHomePage(title: 'Flutter SQLITE'),
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
  late DataConnection db;
  TextEditingController name_controller = TextEditingController();
  TextEditingController sex_controller = TextEditingController();
  TextEditingController age_controller = TextEditingController();
  File? _image;
  late Future<List<Person>> listPerson;
  Future getImagefromCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future getImagefromGallary() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      listPerson = getList()
          .whenComplete(() => Future.delayed(const Duration(seconds: 1)));
    });
  }

  Future<List<Person>> getList() async {
    return await db.getPersonData();
  }

  @override
  void initState() {
    // TODO: implement initState
    db = DataConnection();
    _onRefresh();
    db.initializeData().whenComplete(() async {
      // await Future.delayed(Duration(seconds: 3));
      setState(() {
        listPerson = db.getPersonData();
        print(listPerson.then((value) => value.first.name.toString()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getImagefromGallary();
              });
            },
            icon: const Icon(Icons.image),
          ),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                getImagefromCamera();
              });
            },
            icon: const Icon(Icons.camera_alt),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                      image: _image == null
                          ? const DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/images/def_profile.jpeg'),
                            )
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(_image!.path))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name_controller,
                decoration: const InputDecoration(
                    hintText: 'Enter name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: sex_controller,
                decoration: const InputDecoration(
                    hintText: 'Enter sex', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: age_controller,
                decoration: const InputDecoration(
                    hintText: 'Enter age', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 500,
              width: double.infinity,
              child: FutureBuilder<List<Person>>(
                future: listPerson,
                builder: (context, AsyncSnapshot<List<Person>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Icon(
                        Icons.info,
                        color: Colors.red,
                        size: 30,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var per = snapshot.data![index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateData(person: per),
                                ));
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(File(per.image)),
                              ),
                              title: Text(per.name),
                              subtitle: Text('age : ${per.age}'),
                              trailing: IconButton(
                                  onPressed: () async {
                                    await DataConnection()
                                        .deletePersonData(per.id)
                                        .whenComplete(() => _onRefresh());
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 50,
        child: ElevatedButton(
          child: const Center(child: Text('save')),
          onPressed: () async {
            await DataConnection()
                .insertData(Person(
                    id: Random().nextInt(1000),
                    name: name_controller.text,
                    sex: sex_controller.text,
                    age: int.parse(age_controller.text),
                    image: _image!.path))
                .whenComplete(() => _onRefresh());
          },
        ),
      ),
    );
  }
}
