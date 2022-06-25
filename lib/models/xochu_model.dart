class ResponseXochuData {
  List<XochuProducts>? data;

  ResponseXochuData({this.data});

  ResponseXochuData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <XochuProducts>[];
      json.forEach((v) {
        data!.add(new XochuProducts.fromJson(v));
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
class XochuProducts {
  String? id;
  String? image;
  String? price;
  String? createdAt;
  String? updatedAt;
  Translation? translation;

  XochuProducts(
      {this.id,
        this.image,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.translation});

  XochuProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['price'] = this.price;
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
  String? title;
  String? content;

  Translation({this.id, this.ownerId, this.language, this.title, this.content});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['language'] = this.language;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}