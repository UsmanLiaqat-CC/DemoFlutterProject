class UserModel {
  String? sId;
  String? name;
  String? surName;

  UserModel({
    this.sId,
    this.name,
    this.surName,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      sId: json['_id']?? '',
      name: json['name']?? '',
      surName: json['surName']?? '',

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['surName'] = surName;

    return data;
  }
}
