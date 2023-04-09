import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Panaderia.dart';
import 'Encargado.dart';
import 'Analista.dart';
import 'dart:async';

Future<void> main() async{
  // Observadores
  Encargado encargado = new Encargado();
  Analista analista = new Analista();

  // Observable y completer
  Future<Panaderia> futurePanaderia = Future(() => Panaderia());
  Panaderia panaderia = await futurePanaderia;
  panaderia.inicializarProductos();
  Completer completer = Completer();

  // añadimos los observadores a la panaderia
  panaderia.addObserver(analista);
  panaderia.addObserver(encargado);

  // Función que marca la panadería como cerrada
  void marcarPanaderiaCerrada() {
    print('La panadería ha cerrado');
    completer.complete(); // Completar el futuro
  }

  // Configurar un temporizador para marcar un tiempo límite para la panadería
  Timer(Duration(seconds: 40), marcarPanaderiaCerrada);

  // Ejecutar un proceso mientras la instancia de Future esté activa
  //do {
    //await panaderia.run();
    //encargado.update(panaderia);

    // Comprobar si el futuro ha sido completado y si la panadería sigue abierta
    //print((await futurePanaderia).estaAbierta());
  //} while (!completer.isCompleted && (await futurePanaderia).estaAbierta());
  //print("Ha salido del bucle");


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
  int _counterPanes = 0;
  int _counterCestas = 0;
  double _precioPan = 0.70;
  double _precioCesta = 3.5;
  double _totalPrecioPanes = 0; // dinero a gastar en panes
  double _totalPrecioCestas = 0; // dinero a gastar en cestas
  double _dinero = 50; // dinero del que dispone el cliente
  double _stockPanes = 10;
  double _stockCestas = 10;
  double _stockPanesInicial = 10;
  double _stockCestasInicial = 10;

  Encargado encargado = new Encargado();
  Analista analista = new Analista();
  Panaderia panaderia = new Panaderia();

  _MyHomePageState(){
    panaderia.inicializarProductos();
  }

  void _incrementCounterPanes() {
    setState(() {
      if (_counterPanes < _stockPanes && (_dinero - _precioPan) > 0) {
        _counterPanes++;
        _totalPrecioPanes = _totalPrecioPanes + _precioPan;
        _dinero = _dinero - _precioPan;
      }
    });
  }
  void _decrementCounterPanes() {
    setState(() {
      if (_counterPanes > 0) {
        _counterPanes--;
        _totalPrecioPanes = _totalPrecioPanes - _precioPan;
        _dinero = _dinero + _precioPan;
      }
    });
  }

  void _incrementCounterCestas() {
    setState(() {
      if (_counterCestas < _stockCestas && (_dinero - _precioCesta) > 0) {
        _counterCestas++;
        _totalPrecioCestas = _totalPrecioCestas + _precioCesta;
        _dinero = _dinero - _precioCesta;
      }
    });
  }
  void _decrementCounterCestas() {
    setState(() {
      if (_counterCestas > 0) {
        _counterCestas--;
        _totalPrecioCestas = _totalPrecioCestas - _precioCesta;
        _dinero = _dinero + _precioCesta;
      }
    });
  }

  void _updateStockPanes(){
    print("hola");
    _stockPanes = _stockPanes - _counterPanes;
    _counterPanes = 0;
    _totalPrecioPanes = 0;

    panaderia.venderSimple(_counterPanes);
    encargado.update(panaderia);
  }

  void _updateStockCestas(){
    _stockCestas = _stockCestas - _counterCestas;
    _counterCestas = 0;
    _totalPrecioCestas = 0;

    panaderia.venderCompuesto(_counterCestas);
    encargado.update(panaderia);
  }

  double getStockPanes(){
    return _stockPanes;
  }

  double getStockCestas(){
    return _stockCestas;
  }

  double getStockInicialPanes(){
    return _stockPanesInicial;
  }

  double getStockInicialCestas(){
    return _stockCestasInicial;
  }

  int getStockPanesEncargado(){
    return encargado.getNSimples();
  }
  int getStockCestasEncargado(){
    return encargado.getNSimples();
  }

  int getPanesPanaderia(){
    return panaderia.getNSimples();
  }

  int getCestasPanaderia(){
    return panaderia.getNCompuestos();
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
                  'Stock panes: ' + _stockPanes.toString(),
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
                        onPressed: _decrementCounterPanes,
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 15),
                      Text(
                        _counterPanes.toString(),
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _incrementCounterPanes,
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Text(
                  'Total euros: ' + _totalPrecioPanes.toStringAsFixed(2) + '€',
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
                  'Stock cestas: ' + _stockCestas.toString(),
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
                        onPressed: _decrementCounterCestas,
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 15),
                      Text(
                        _counterCestas.toString(),
                      ),
                      SizedBox(width: 15),
                      FloatingActionButton(
                        onPressed: _incrementCounterCestas,
                        child: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Text(
                  'Total euros: ' + _totalPrecioCestas.toStringAsFixed(2) + '€',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 50,),
                Text(
                  'Dinero: ' + _dinero.toStringAsFixed(2),
                ),
                SizedBox(width: 50,),
                ElevatedButton(
                  onPressed: () {
                    setState((){
                      _updateStockPanes();
                      _updateStockCestas();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen(myHome: this)),
                    );
                  },
                  child: Text('Comprar'),
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
  final _MyHomePageState myHome;
  // final double stockPanes;

  SecondScreen({required this.myHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ventas'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 220,),
            Text(
              'Se han vendido: ' + ( (myHome.getStockInicialPanes() - myHome.getStockPanes()).toInt() ).toString() + ' panes.',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              'Se han vendido: ' + ( (myHome.getStockInicialPanes() - myHome.getStockCestas()).toInt() ).toString() + ' cestas.',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 60,),
            Text(
              "Encargado:",
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: 30,),
            Text(
              'Panes vendidos del encargado: ' + ( myHome.getStockPanesEncargado() ).toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              'Cestas vendidas del encargado: ' + ( myHome.getStockCestasEncargado() ).toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              'Stock panes panaderia: ' + ( myHome.getPanesPanaderia() ).toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              'Stock cestas panaderia: ' + ( myHome.getCestasPanaderia() ).toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
