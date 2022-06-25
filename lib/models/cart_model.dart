class ResponseCartData {
  List<CartModel>? data;

  ResponseCartData({this.data});

  ResponseCartData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <CartModel>[];
      json.forEach((v) {
        data!.add(new CartModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class CartModel {
  String? id;
  String? quantity;
  String? buyImage;
  String? winImage;
  String? title;
  int? price;
  int? qty;
  int? tickets;
  String? timer;

  CartModel(
      {this.id,
        this.quantity,
        this.buyImage,
        this.winImage,
        this.title,
        this.price,
        this.qty,
        this.tickets,
        this.timer});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    buyImage = json['buy_image'];
    winImage = json['win_image'];
    title = json['title'];
    price = json['price'];
    qty = json['qty'];
    tickets = json['tickets'];
    timer = json['timer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['buy_image'] = this.buyImage;
    data['win_image'] = this.winImage;
    data['title'] = this.title;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['tickets'] = this.tickets;
    data['timer'] = this.timer;
    return data;
  }
}