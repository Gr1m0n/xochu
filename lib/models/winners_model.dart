class ResponseWinnersData {
  List<WinnersModel>? data;

  ResponseWinnersData({this.data});

  ResponseWinnersData.fromJson(List<dynamic> json) {
    if (json != null) {
      data = <WinnersModel>[];
      json.forEach((v) {
        data!.add(new WinnersModel.fromJson(v));
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
class WinnersModel {
  String? image;
  String? user;
  String? title;
  String? coupon;
  String? youtube;
  String? avatar;

  WinnersModel(
      {this.image,
        this.user,
        this.title,
        this.coupon,
        this.youtube,
        this.avatar});

  WinnersModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    user = json['user'];
    title = json['title'];
    coupon = json['coupon'];
    youtube = json['youtube'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['user'] = this.user;
    data['title'] = this.title;
    data['coupon'] = this.coupon;
    data['youtube'] = this.youtube;
    data['avatar'] = this.avatar;
    return data;
  }
}