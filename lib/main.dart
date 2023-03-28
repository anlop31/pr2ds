import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Panaderia.dart';
import 'Encargado.dart';
import 'Analista.dart';

void main() {



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Panadería'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(


        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(
                  'Stock panes: ' + _counter.toString(),
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                Image.asset('assets/pan.jpeg', width: 155, height: 180,),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cantidad: ',
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _decrementCounter,
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 15),
                      Text(
                        _counter.toString(),
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _incrementCounter,
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Text(
                  'Total euros: ' + _counter.toString() + '€',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Column(
              children: [
                Text(
                  'Stock cestas: ' + _counter.toString(),
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                Image.asset('assets/cesta.jpeg', width: 180, height: 180,),
                Center(
                  child :Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cantidad: ',
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _decrementCounter,
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 15),
                      Text(
                        _counter.toString(),
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _incrementCounter,
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Text(
                  'Total euros: ' + _counter.toString() + '€',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 20,),
                Text(
                  'Dinero: ' + _counter.toString(),
                ),
                SizedBox(width: 50,),
                RaisedButton(
                  onPressed: _incrementCounter,
                  child: Text('Comprar'),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),

          ],
        ),

      ),

    );
  }

}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda pantalla'),
      ),
      body: Center(
        child: Text('Estás en la segunda pantalla'),
      ),
    );
  }
}
