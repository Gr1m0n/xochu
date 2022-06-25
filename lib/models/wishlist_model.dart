class ResponseWishlistData {
  List<WishlistModel>? data;

  ResponseWishlistData({this.data});

  ResponseWishlistData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <WishlistModel>[];
      json.forEach((v) {
        data!.add(new WishlistModel.fromJson(v));
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
class WishlistModel {
  int? id;
  String? buyImage;
  String? winImage;
  String? title;
  int? price;
  int? tickets;
  String? timer;

  WishlistModel(
      {this.id,
        this.buyImage,
        this.winImage,
        this.title,
        this.price,
        this.tickets,
        this.timer});

  WishlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyImage = json['buy_image'];
    winImage = json['win_image'];
    title = json['title'];
    price = json['price'];
    tickets = json['tickets'];
    timer = json['timer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buy_image'] = this.buyImage;
    data['win_image'] = this.winImage;
    data['title'] = this.title;
    data['price'] = this.price;
    data['tickets'] = this.tickets;
    data['timer'] = this.timer;
    return data;
  }
}