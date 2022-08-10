class Person {
  late int id;
  late String name;
  late String sex;
  late int age;
  late String image;
  Person(
      {required this.id,
      required this.name,
      required this.sex,
      required this.age,
      required this.image});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sex': sex,
      'age': age,
      'image': image,
    };
  }

  Person.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        sex = res['sex'],
        age = res['age'],
        image = res['image'];
}
