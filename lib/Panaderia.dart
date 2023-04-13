import 'dart:async';
import 'dart:math';
import 'Producto.dart';
import 'Observer.dart';
import 'ProductoCompuesto.dart';
import 'ProductoSimple.dart';

class Panaderia extends Observable{
/*
Panaderia : se encarga de instanciar los objetos y notificar
al observador las cantidades
*/

    final Random rand = Random();

    int _nSimples = 0;
    int _nCompuestos = 0;
    int _nProd = 0;
    int _simplesVendidos = 0;
    int _compuestosVendidos = 0;
    int _stockInicialPanes = 0;
    int _stockInicialCestas = 0;

    //arrays de productos
    List<Producto> stockSimples = [];
    List<Producto> stockCompuestos = [];

    //array de suscriptores
    //List<Observer> _observers = [];
    // este array no es, ya está en la clase Observable!!!
    //      y se accede a _observers desde las funciones de Observable

    Panaderia() {
        stockSimples = [];
        stockCompuestos = [];
        //_observers = [];
        _simplesVendidos = 0;
        _compuestosVendidos = 0;
        // inicializarProductos(); // se ejecuta 2 veces, por que?
    }

    //Getters  
    int getNSimples(){
        return _nSimples;
    }

    int getNCompuestos(){
        return _nCompuestos;
    }

    int getSimplesVendidos(){
        return _simplesVendidos;
    }

    int getCompuestosVendidos(){
        return _compuestosVendidos;
    }

    int getStockInicialPanes(){
        return _stockInicialPanes;
    }

    int getStockInicialCestas(){
        return _stockInicialCestas;
    }


    // Setters
    void setNSimples(int n){
        this._nSimples = n;
    }

    void setNCompuestos(int n){
        this._nCompuestos = n;
    }

    void setSimplesVendidos(int n){
        this._simplesVendidos = n;
    }

    void setCompuestosVendidos(int n){
        this._compuestosVendidos = n;
    }

    bool estaCerrada = false;

    bool estaAbierta() {
        //print("en esta abierta estacerrada es $estaCerrada");
        return !estaCerrada;
    }

    void setCerrada(bool b){
      estaCerrada = b;
    }

    void inicializarProductos() {
        //Genera las cantidades de productos de cada tipo
        //y añade dicha cantidad de productos al arraylist correspondiente
        _nSimples = rand.nextInt(20) + 10;
        _nCompuestos = rand.nextInt(20) + 10;
        _nProd = _nSimples + _nCompuestos;

        _stockInicialPanes = _nSimples;
        _stockInicialCestas = _nCompuestos;

        // notifyObservers(this);
        // no hace falta este notify, ya que update se llama
        // cada vez que hay una venta, y ya sabe reaccionar con la primera
        // venta

        for (int i = 0; i < _nSimples; i++) {
            this.stockSimples.add(ProductoSimple());
        }

        for (int i = 0; i < _nCompuestos; i++) {
            this.stockCompuestos.add(ProductoCompuesto());
        }

        print("Se inicializa con " + _nSimples.toString() + " productos simples y " + _nCompuestos.toString() + " compuestos. Total: " + _nProd.toString());
    }

    // Manejar suscriptores
    void adscribir(Observer observador) {
        addObserver(observador);
        //_observers.add(observador);
    }

    void quitar(Observer observador) {
        //_observers.remove(observador);
        removeObserver(observador);
    }

    // MÉTODOS PARA VENDER
    void venderSimple(int n){
        if (_nSimples <= 0){ // si no quedan simples
            _nSimples = 0;
            print("Se han acabado los panes");
        }
        else{ // si quedan simples
            if(n <= _nSimples){
                _simplesVendidos += n;
                for (int i = 0; (i < n) && stockSimples.isNotEmpty; i++){
                    stockSimples.removeLast();
                }
                _nSimples -= n;
                print("$n panes vendidos y quedan $_nSimples == ${stockSimples.length}");
            }
            else{
            print("No hay suficientes panes");
            }
        }

        //notifyObservers(this); // mejor se llama en venderProducto(s)
    }


    void venderCompuesto(int n){
        if(_nCompuestos <= 0){ // si no quedan compuestos
            _nCompuestos = 0;
            print("Se han acabado las cestas");
        }
        else{ // si quedan compuestos
            if(n <= _nCompuestos){
                _compuestosVendidos += n;
                for (int i = 0; (i < n) && stockCompuestos.isNotEmpty; i++){
                    stockCompuestos.removeLast();
                }
                _nCompuestos -= n;
                print("$n cestas vendidas y quedan $_nCompuestos == ${stockCompuestos.length}");
            }
            else{
                print("No hay suficientes cestas");
            }
        }

        //notifyObservers(this); // mejor se llama en venderProducto(s)
    } 

    void venderProducto(int tipo, int cantidad){
        // Print para comprobar que está ejecutándose
        print("Se van a vender $cantidad productos de tipo $tipo");
        if (tipo == 0){
            venderSimple(cantidad);
        } else { // si tipo == 1
            venderCompuesto(cantidad);
        }

        notifyObservers(this);
    }

    void venderProductos(int cantidad_panes, int cantidad_cestas){
        print("Se van a vender $cantidad_panes panes y $cantidad_cestas cestas");

        venderSimple(cantidad_panes);
        venderCompuesto(cantidad_cestas);

        notifyObservers(this);
    }




Future<void> run() async{
    //Cada cierto tiempo (instante) se vende una serie de productos 
    //(cantidad) de un tipo u otro (tipo)
    if (_nProd > 0){ // si hay productos, vende
        //this.setChanged();
        int instante = rand.nextInt(4)+1;
        int tipo = rand.nextInt(2);
        int cantidad = rand.nextInt(4)+1;
        await Future.delayed(Duration(seconds:instante));
        venderProducto(tipo, cantidad);
    
        _nProd = _nSimples + _nCompuestos;
    }
    else{ // si no hay productos, cierra la panaderia
      setCerrada(true);
      print("SE CIERRA LA PANADERIA.");
    }

}



}