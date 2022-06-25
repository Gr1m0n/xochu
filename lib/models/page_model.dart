class ResponsePageData {
  List<PageModel>? data;

  ResponsePageData({this.data});

  ResponsePageData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <PageModel>[];
      json.forEach((v) {
        data!.add(new PageModel.fromJson(v));
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
class PageModel {
  String? id;
  String? view;
  String? aboutImage;
  String? email;
  String? phone;
  String? latitude;
  String? longitude;
  String? instagram;
  String? facebook;
  String? createdAt;
  String? updatedAt;
  Translation? translation;

  PageModel(
      {this.id,
        this.view,
        this.aboutImage,
        this.email,
        this.phone,
        this.latitude,
        this.longitude,
        this.instagram,
        this.facebook,
        this.createdAt,
        this.updatedAt,
        this.translation});

  PageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    view = json['view'];
    aboutImage = json['about_image'];
    email = json['email'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['view'] = this.view;
    data['about_image'] = this.aboutImage;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['instagram'] = this.instagram;
    data['facebook'] = this.facebook;
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
  String? body;
  String? address;
  String? image;
  String? mobileImage;

  Translation(
      {this.id,
        this.ownerId,
        this.language,
        this.title,
        this.body,
        this.address,
        this.image,
        this.mobileImage});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    title = json['title'];
    body = json['body'];
    address = json['address'];
    image = json['image'];
    mobileImage = json['mobile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['language'] = this.language;
    data['title'] = this.title;
    data['body'] = this.body;
    data['address'] = this.address;
    data['image'] = this.image;
    data['mobile_image'] = this.mobileImage;
    return data;
  }
}