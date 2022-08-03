class Person {
  late int id;
  late String name;
  late String sex;
  late int age;
  Person(
      {required this.id,
      required this.name,
      required this.sex,
      required this.age});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'age': age,
    };
  }

  Person.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sex = res['sex'],
        age = res['age'];
}
