// 부모 클래스
abstract class Animal {
  String _name; // private 변수
  String get name => _name;

  Animal(this._name);

  void makeSound();
}

// 자식 클래스 (Animal 상속)
class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void makeSound() {
    print('$name이(가) 월월!');
  }
}

class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  void makeSound() {
    print('$name이(가) 냐옹!');
  }
}

void main() {
  //var animal = Animal('동물?');
  Dog dog1 = Dog("꽁치");
  Dog dog2 = Dog("도미");
  Cat cat1 = Cat("나비");
  Cat cat2 = Cat("귤");

  List<Animal> animals = [dog1, dog2, cat1, cat2];

  for (var animal in animals) {
    animal.makeSound();
  }
}
