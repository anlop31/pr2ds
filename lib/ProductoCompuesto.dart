import 'Producto.dart';
import 'ProductoSimple.dart';

class ProductoCompuesto extends Producto {
  List<Producto> productos = [new ProductoSimple()];
  int componentes = 0;

//   ProductoCompuesto()
//       : productos = List<Object>(),
//         componentes = 0,
//         ProductoSimple producto = new ProductoSimple(),
//         productos.add(producto),
//         super();

    ProductoCompuesto() :
        super();

  void anadirProducto(Producto prod) {
    productos.add(prod);
  }

  void eliminarProducto(Producto prod) {
    productos.remove(prod);
  }

  Producto obtenerProducto(int identificador) {
    return productos[identificador];
  }
}
