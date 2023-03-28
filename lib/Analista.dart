//import 'dart:_js_primitives';
//import 'dart:collection';

//import 'package:flutter/material.dart';

import 'Panaderia.dart';
import 'Observer.dart';

class Analista extends Observer<Panaderia> {

    List<int> _ventasDia = [];
    List<int> _ventasTotales = [];

    int _contador = 0;
    int _dia_semana = 0;
    int _suma = 0;

    double _precioCestas = 0.0;
    double _precioPan = 0.0;

    int _nSimples = 0;
    int _nCompuestos = 0;
    int _simplesVendidos = 0;
    int _compuestosVendidos = 0;

    String _mensajeSimples = "";
    String _mensajeCompuestos = "";

    
    Analista() {
        for (int i = 0; i < 7; i++) {
            _ventasTotales.add(0);
        }
    }

    @override
    void update(Observable o) {
        //Se le avisa de los productos disponibles en la tienda y los que ya se han vendido
        try {
            Future.delayed(Duration(milliseconds: 500));
        } catch (ex) {}

        Panaderia panaderia = new Panaderia();
        int nSimples = (o as Panaderia).getNSimples();
        int nCompuestos = (o as Panaderia).getNCompuestos();
        int simplesVendidos = (o as Panaderia).getSimplesVendidos();
        int compuestosVendidos = (o as Panaderia).getCompuestosVendidos();
        panaderia.setNSimples(nSimples);
        panaderia.setNCompuestos(nCompuestos);
        panaderia.setSimplesVendidos(simplesVendidos);
        panaderia.setCompuestosVendidos(compuestosVendidos);
        
        _suma = 0;
        int vendidos = (_nSimples+_nCompuestos) - ( panaderia.getNSimples()+panaderia.getNCompuestos() );


        if(_dia_semana < 7){
            if (_contador == 0){
                _contador = _contador + 1;
            }
            else if(_contador == 4){
                _contador = 1;

                for(int i=0; i<3; i++){
                    _suma = _suma + _ventasDia[i];
                    print("suma: " + _suma.toString() + " ventasDia.get(" + i.toString() + "):" + _ventasDia[i].toString());
                }

                _ventasTotales[_dia_semana] = _suma;

                // print dia semana con ventas y contador

                _dia_semana = _dia_semana + 1;

                _ventasDia.clear();
                _ventasDia.add(vendidos);
            }
            else{
                // print dia semana con contador 
                _ventasDia.add(vendidos);
                _contador = _contador + 1;
            }

            _nSimples = panaderia.getNSimples();
            _nCompuestos = panaderia.getNCompuestos();
            _simplesVendidos = panaderia.getSimplesVendidos();
            _compuestosVendidos = panaderia.getCompuestosVendidos();

            _mensajeSimples = "(Analista) El numero de panes en stock es " + _nSimples.toString()  + " y ya se han vendido " + _simplesVendidos.toString();
            _mensajeCompuestos = "(Analista) El numero de cestas en stock es " + _nCompuestos.toString() + " y ya se han vendido " + _compuestosVendidos.toString();

            print(_mensajeSimples);
            print(_mensajeCompuestos);
        }
    }

    String getStock(){
        return ("Analista --> " + _mensajeSimples + _mensajeCompuestos);
    }
}