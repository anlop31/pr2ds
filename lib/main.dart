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
    //print('La panadería ha cerrado');
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
  int _vendidosPan = 0;
  int _vendidosCesta = 0;

  Encargado encargado = new Encargado();
  Analista analista = new Analista();
  Panaderia panaderia = new Panaderia();

  _MyHomePageState(){
    panaderia.adscribir(analista);
    panaderia.inicializarProductos();
    //inicializarPanaderia();
    _stockPanes = panaderia.getNSimples().toDouble();
    _stockCestas = panaderia.getNCompuestos().toDouble();

  }

  void _incrementCounterPanes() {
    setState(() {
      if (_counterPanes < _stockPanes && (_dinero - _precioPan) > 0) {
        _counterPanes++;
        _totalPrecioPanes = _totalPrecioPanes + _precioPan;
        _dinero = _dinero - _precioPan;
      } else if ((_dinero - _precioPan) < 0){
        showPopUpMoney(context);
      } else {
        showPopUpStock(context);
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
      } else if ((_dinero - _precioCesta) < 0){
        showPopUpMoney(context);
      } else {
        showPopUpStock(context);
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
    setState(() {
      _vendidosPan = _vendidosPan + _counterPanes;
      panaderia.venderProducto(0, _counterPanes);

      _stockPanes = _stockPanes - _counterPanes;
      _counterPanes = 0;
      _totalPrecioPanes = 0;

      encargado.update(panaderia);
    });
  }

  void _updateStockCestas(){
    setState(() {
      _vendidosCesta = _vendidosCesta + _counterCestas;
      panaderia.venderProducto(1, _counterCestas);

      _stockCestas = _stockCestas - _counterCestas;
      _counterCestas = 0;
      _totalPrecioCestas = 0;

      encargado.update(panaderia);
    });
  }

  void _updateStock(){
    setState((){
      panaderia.venderProductos(_counterPanes, _counterCestas);

      ///// Panes
      _vendidosPan = _vendidosPan + _counterPanes;
      //panaderia.venderProducto(0, _counterPanes);

      // actualizar stock y reiniciar contadores
      _stockPanes = _stockPanes - _counterPanes;
      _counterPanes = 0;
      _totalPrecioPanes = 0;

      ///// Cestas
      _vendidosCesta = _vendidosCesta + _counterCestas;
      //panaderia.venderProducto(1, _counterCestas);

      // actualizar stock y reiniciar contadores
      _stockCestas = _stockCestas - _counterCestas;
      _counterCestas = 0;
      _totalPrecioCestas = 0;

      encargado.update(panaderia);
    });
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
    return encargado.getNCompuestos();
  }

  int getPanesPanaderia(){
    return panaderia.getNSimples();
  }

  int getCestasPanaderia(){
    return panaderia.getNCompuestos();
  }

  int getVentasDia(int dia){
    return analista.getVentasDia(dia);
  }


  int getVendidosPan(){
    return _vendidosPan;
  }

  int getVendidosCesta(){
    return _vendidosCesta;
  }

  //pop up para cuando no hay suficiente dinero
  void showPopUpMoney(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No hay suficiente dinero"),
          content: Text("No tienes suficiente dinero para comprar este producto."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //pop up para cuando no hay suficiente stock
  void showPopUpStock(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No hay suficiente stock"),
          content: Text("El producto que desea comprar no está disponible."),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            /*FloatingActionButton(
              onPressed: () => _inicializarPanes,
              child: Icon(Icons.visibility_rounded),
            ),*/
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
                      //_updateStockPanes();
                      //_updateStockCestas();
                      if(_counterPanes == 0 && _counterCestas != 0){
                        _updateStockCestas(); // se venden solo cestas
                      }
                      else if(_counterPanes != 0 && _counterCestas == 0){
                        _updateStockPanes(); // se venden solo panes
                      }
                      else if(_counterPanes != 0 && _counterCestas != 0){
                        _updateStock(); // se venden panes y cestas
                      }
                      //_updateStock();
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
        title: Text('Vista para empleados'),
      ),
      body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child:
        Column(
          children: [
            SizedBox(height: 90,),
            Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(9.0),
            child: Text(
                ' Ventas ',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Column(
                children: [
                  Text(
                    //'Se han vendido: ' + ( (myHome.getStockInicialPanes() - myHome.getStockPanes()).toInt() ).toString() + ' panes.',
                    'Se han vendido: ' + myHome.getVendidosPan().toString() + ' panes.',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    //'Se han vendido: ' + ( (myHome.getStockInicialCestas() - myHome.getStockCestas()).toInt() ).toString() + ' cestas.',
                    'Se han vendido: ' + myHome.getVendidosCesta().toString() + ' cestas.',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(9.0),
              child: Text(
                ' Encargado ',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Stock panes según el encargado: ' + ( myHome.getStockPanesEncargado() ).toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              'Stock cestas según el encargado: ' + ( myHome.getStockCestasEncargado() ).toString(),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 50,),
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(9.0),
              child: Text(
                ' Analista ',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(height: 30,),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('L',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('M',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('X',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('J',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('V',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('S',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('D',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(myHome.getVentasDia(0).toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(myHome.getVentasDia(1).toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(myHome.getVentasDia(2).toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(myHome.getVentasDia(3).toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child:
                          Text(myHome.getVentasDia(4).toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                            ),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child:
                          Text(myHome.getVentasDia(5).toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                            ),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child:
                          Text(myHome.getVentasDia(6).toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                          ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
