import 'package:shelf_plus/shelf_plus.dart';

class Person {
  final String? name;
  final int? age;

  const Person({    
    required this.name,
    required this.age,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "age": age};  
}

extension PersonAccessor on RequestBodyAccessor {
  Future<Person> get asPerson async => Person.fromJson(await asJson); 
}