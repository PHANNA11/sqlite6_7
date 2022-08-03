import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  TextEditingController name_controller = TextEditingController();
  TextEditingController sex_controller = TextEditingController();
  TextEditingController age_controller = TextEditingController();
  File? _image;
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
              //  color: Colors.red,
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(index.toString())),
                      title: const Text('Hello'),
                      subtitle: const Text('age : 18'),
                    ),
                  );
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
          onPressed: () {},
        ),
      ),
    );
  }
}
