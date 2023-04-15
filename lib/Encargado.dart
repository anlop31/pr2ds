//import 'dart:async';
import 'Observer.dart';
import 'Panaderia.dart';

class Encargado implements Observer<Panaderia> {
    double _precioCestas = 0;
    double _precioPan = 0;
    int _nSimples = 0;
    int _nCompuestos = 0;
    int _simplesVendidos = 0;
    int _compuestosVendidos = 0;
    String _mensajeSimples = "";
    String _mensajeCompuestos = "";

    Encargado() {
        _precioCestas = 0;
        _precioPan = 0;
        _nSimples = 0;
        _nCompuestos = 0;
        _simplesVendidos = 0;
        _compuestosVendidos = 0;
        _mensajeSimples = "NADA";
        _mensajeCompuestos = "NADA";
    }

    void update(Observable o) {
        //Se le avisa de los productos disponibles en la tienda y los que ya se han vendido
        Future.delayed(Duration(milliseconds: 500));
        
        Panaderia panaderia = o as Panaderia;
        // List<int> datos = arg as List<int>;

        _nSimples = panaderia.getNSimples();
        _nCompuestos = panaderia.getNCompuestos();
        _simplesVendidos = panaderia.getSimplesVendidos();
        _compuestosVendidos = panaderia.getCompuestosVendidos();

        _mensajeSimples = "(Encargado) El número de panes en stock es " + _nSimples.toString() + " y ya se han vendido " + _simplesVendidos.toString();
        _mensajeCompuestos = "(Encargado) El número de cestas en stock es $_nCompuestos y ya se han vendido $_compuestosVendidos";

        print(_mensajeSimples);
        print(_mensajeCompuestos);
    }

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

    String getStock(){
        return ("Supervisor --> " + _mensajeSimples + _mensajeCompuestos);
    }
}