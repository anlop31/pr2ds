// Define una clase abstracta para el observador
abstract class Observer<T> {
  //void update(T subject);
  void update(T subject);
}

// Define una clase de sujeto observable

class Observable<T> {
  final List<Observer<T>> _observers = [];

  void addObserver(Observer<T> observer) {
    _observers.add(observer);
  }

  void removeObserver(Observer<T> observer) {
    _observers.remove(observer);
  }

  void notifyObservers(T subject) {
    for (var observer in _observers) {
      observer.update(subject);
    }
  }
} 

// Implementa un observador que registra cuando el sujeto cambia
class MyObserver implements Observer<String> {
  @override
  void update(String subject) {
    print('El sujeto ha cambiado a: $subject');
  }
}

// Usa el patrón Observer
void main() {
  final observable = Observable<String>();
  final observer = MyObserver();

  observable.addObserver(observer);

  observable.notifyObservers('hola mundo');
  // El resultado será: "El sujeto ha cambiado a: hola mundo"

  observable.removeObserver(observer);
}

/*
class Observable<T> {
  final List<Observer<T>> _observers = [];

  void addObserver(Observer<T> observer) {
    _observers.add(observer);
  }

  void removeObserver(Observer<T> observer) {
    _observers.remove(observer);
  }

  void notifyObservers(T subject) {
    for (var observer in _observers) {
      observer.update(subject);
    }
  }
} */