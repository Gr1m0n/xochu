class ResponseFaqData {
  List<FaqModel>? data;

  ResponseFaqData({this.data});

  ResponseFaqData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <FaqModel>[];
      json.forEach((v) {
        data!.add(new FaqModel.fromJson(v));
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
class FaqModel {
  String? id;
  String? category;
  String? createdAt;
  String? updatedAt;
  Translation? translation;

  FaqModel(
      {this.id,
        this.category,
        this.createdAt,
        this.updatedAt,
        this.translation});

  FaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    translation = json['translation'] != null
        ? new Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
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

  Translation({this.id, this.ownerId, this.language, this.title, this.body});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    language = json['language'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['language'] = this.language;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}