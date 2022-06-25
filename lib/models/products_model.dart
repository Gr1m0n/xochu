class ResponseData {
  List<DataModel>? data;

  ResponseData({this.data});

  ResponseData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <DataModel>[];
      json.forEach((v) {
        data!.add(new DataModel.fromJson(v));
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

class DataModel {
  String? id;
  String? buyImage;
  String? winImage;
  String? prizeImage;
  String? tickets;
  String? quantity;
  String? timer;
  String? drawDate;
  String? price;
  String? deliveryPrice;
  String? coupon;
  String? homepage;
  String? sale;
  String? catalog;
  String? createdAt;
  String? updatedAt;
  Translation? translation;

  DataModel(
      {this.id,
        this.buyImage,
        this.winImage,
        this.prizeImage,
        this.tickets,
        this.quantity,
        this.timer,
        this.drawDate,
        this.price,
        this.deliveryPrice,
        this.coupon,
        this.homepage,
        this.sale,
        this.catalog,
        this.createdAt,
        this.updatedAt,
        this.translation});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyImage = json['buy_image'];
    winImage = json['win_image'];
    prizeImage = json['prize_image'];
    tickets = json['tickets'];
    quantity = json['quantity'];
    timer = json['timer'];
    drawDate = json['draw_date'];
    price = json['price'];
    deliveryPrice = json['delivery_price'];
    coupon = json['coupon'];
    homepage = json['homepage'];
    sale = json['sale'];
    catalog = json['catalog'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buy_image'] = this.buyImage;
    data['win_image'] = this.winImage;
    data['prize_image'] = this.prizeImage;
    data['tickets'] = this.tickets;
    data['quantity'] = this.quantity;
    data['timer'] = this.timer;
    data['draw_date'] = this.drawDate;
    data['price'] = this.price;
    data['delivery_price'] = this.deliveryPrice;
    data['coupon'] = this.coupon;
    data['homepage'] = this.homepage;
    data['sale'] = this.sale;
    data['catalog'] = this.catalog;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.translation != null) {
      data['translation'] = this.translation!.toJson();
    }
    return data;
  }
}

class Translation {
  String? id;
  String? ownerId;
  String? language;
  String? buyTitle;
  String? buyBody;
  String? prizeBody;
  String? winTitle;
  String? winBody;

  Translation(
      {this.id,
        this.ownerId,
        this.language,
        this.buyTitle,
        this.buyBody,
        this.prizeBody,
        this.winTitle,
        this.winBody});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    buyTitle = json['buy_title'];
    buyBody = json['buy_body'];
    prizeBody = json['prize_body'];
    winTitle = json['win_title'];
    winBody = json['win_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['language'] = this.language;
    data['buy_title'] = this.buyTitle;
    data['buy_body'] = this.buyBody;
    data['prize_body'] = this.prizeBody;
    data['win_title'] = this.winTitle;
    data['win_body'] = this.winBody;
    return data;
  }
}