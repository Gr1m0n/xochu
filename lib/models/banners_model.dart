class ResponseBannersData {
  List<BannersModel>? data;

  ResponseBannersData({this.data});

  ResponseBannersData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <BannersModel>[];
      json.forEach((v) {
        data!.add(new BannersModel.fromJson(v));
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
class BannersModel {
  String? id;
  String? position;
  String? productID;
  String? createdAt;
  String? updatedAt;
  Translation? translation;

  BannersModel(
      {this.id,
      this.position,
      this.productID,
      this.createdAt,
      this.updatedAt,
      this.translation});

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    productID = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['product_id'] = this.productID;
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
  String? desktop;
  String? mobile;
  String? url;

  Translation(
      {this.id,
      this.ownerId,
      this.language,
      this.title,
      this.desktop,
      this.mobile,
      this.url});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    title = json['title'];
    desktop = json['desktop'];
    mobile = json['mobile'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['language'] = this.language;
    data['title'] = this.title;
    data['desktop'] = this.desktop;
    data['mobile'] = this.mobile;
    data['url'] = this.url;
    return data;
  }
}
