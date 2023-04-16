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


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Panadería'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
      } else {
        _counterPanes = 0;
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
      } else {
        _counterCestas = 0;
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

      // actualizar stock y reiniciar contadores
      _stockPanes = _stockPanes - _counterPanes;
      _counterPanes = 0;
      _totalPrecioPanes = 0;

      ///// Cestas
      _vendidosCesta = _vendidosCesta + _counterCestas;

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

  void _comprar(){
    setState((){
      if(_counterPanes == 0 && _counterCestas != 0){
        _updateStockCestas(); // se venden solo cestas
      }
      else if(_counterPanes != 0 && _counterCestas == 0){
        _updateStockPanes(); // se venden solo panes
      }
      else if(_counterPanes != 0 && _counterCestas != 0){
        _updateStock(); // se venden panes y cestas
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: TextStyle(
            color: Colors.white,
          ),),
      ),
      body:
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondo.png'),
              fit: BoxFit.cover,
            ),
          ),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text(
                  'Acceso para empleados',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(200, 80)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondScreen(myHome: this)),
                );
              },
            ),
            SizedBox(height: 50,),
            ElevatedButton(
              child: Text(
                  'Acceso para clientes',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,

                ),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(200, 80)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdScreen(myHome: this)),
                );
              },
            ),
          ],
        ),
        ),
      ),

    );
  }

}



class SecondScreen extends StatelessWidget {

  final _MyHomePageState myHome;
  SecondScreen({required this.myHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista para empleados',),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
        ),
      child:
      Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child:
        Column(
          children: [
            SizedBox(height: 90,),
            Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.all(9.0),
            child: Text(
                ' Ventas ',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Column(
                children: [
                  Text(
                    'Se han vendido: ' + myHome.getVendidosPan().toString() + ' panes.',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
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
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(9.0),
              child: Text(
                ' Encargado ',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
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
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(9.0),
              child: Text(
                ' Analista ',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
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
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('L',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('M',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('X',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('J',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('V',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('S',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        border: Border.all(),
                      ),
                      height: 50,
                      child: Center(
                        child: Text('D',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
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
      ),
    );
  }
}


class ThirdScreen extends StatefulWidget {
  final _MyHomePageState myHome;

  const ThirdScreen({Key? key, required this.myHome}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen>{

  void _decrementCounterCestas(){
    setState(() {
      widget.myHome._decrementCounterCestas();
    });
  }

  void _incrementCounterCestas(){
    setState(() {
      widget.myHome._incrementCounterCestas();
    });
  }

  void _decrementCounterPanes(){
    setState(() {
      widget.myHome._decrementCounterPanes();
    });
  }

  void _incrementCounterPanes(){
    setState(() {
      widget.myHome._incrementCounterPanes();
    });
  }

  void _comprar(){
    setState(() {
      widget.myHome._comprar();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista para clientes'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
        ),
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [

                Text(
                  'Stock panes: ' + widget.myHome._stockPanes.toString(),
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
                        widget.myHome._counterPanes.toString(),
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
                  'Total euros: ' + widget.myHome._totalPrecioPanes.toStringAsFixed(2) + '€',
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
                  'Stock cestas: ' + widget.myHome._stockCestas.toString(),
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
                        widget.myHome._counterCestas.toString(),
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
                  'Total euros: ' + widget.myHome._totalPrecioCestas.toStringAsFixed(2) + '€',
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
                  'Dinero: ' + widget.myHome._dinero.toStringAsFixed(2),
                ),
                SizedBox(width: 50,),
                ElevatedButton(
                  onPressed: () {
                    _comprar();
                  },
                  child: Text('Comprar'),
                ),
              ],
            ),

          ],
        ),

      ),
      ),
    );
  }
}



