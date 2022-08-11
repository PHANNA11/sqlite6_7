import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite6_7/main.dart';
import 'package:sqlite6_7/models/person_model.dart';

import 'connection/database_connection.dart';

class UpdateData extends StatefulWidget {
  UpdateData({required this.person, Key? key}) : super(key: key);
  Person person;
  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
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

  // Future<void> _onRefresh() async {
  //   setState(() {
  //     listPerson = getList()
  //         .whenComplete(() => Future.delayed(const Duration(seconds: 1)));
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name_controller.text = widget.person.name;
    sex_controller.text = widget.person.sex;
    age_controller.text = widget.person.age.toString();
    _image = File(widget.person.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
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
                      image: widget.person.image == null
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
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 50,
        child: ElevatedButton(
          child: const Center(child: Text('update')),
          onPressed: () async {
            await DataConnection()
                .updatePersonData(Person(
                    id: widget.person.id,
                    name: name_controller.text,
                    sex: sex_controller.text,
                    age: int.parse(age_controller.text),
                    image: _image == null ? widget.person.image : _image!.path))
                .whenComplete(() => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                    (route) => false));
          },
        ),
      ),
    );
  }
}
