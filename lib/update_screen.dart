import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name_controller.text = widget.person.name;
    sex_controller.text = widget.person.sex;
    age_controller.text = widget.person.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
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
                    age: int.parse(age_controller.text)))
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
