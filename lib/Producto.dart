abstract class Producto {
  String nombre = "";
  double precio = 0.0;
  int stock = 0;
  int stockInicial = 0;

  int informarStock() {
    return stock;
  }

  int informarVendidos() {
    return stockInicial - stock;
  }

  void setPrecio(double precio) {
    this.precio = precio;
  }

  void setStock(int stock) {
    this.stock = stock;
  }
}
