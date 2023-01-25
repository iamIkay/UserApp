class User {
  String? id;
  String? bio;
  bool? verified;
  bool? isHost;
  String? wallet;
  String? stripeCustomerId;
  int? followersCount;
  int? followedCount;
  int? hostedEvenCount;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNum;
  String? profileImg;
  String? token;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNum,
      this.bio,
      this.isHost = false,
      this.verified = false,
      this.followedCount,
      this.followersCount,
      this.hostedEvenCount,
      this.wallet,
      this.stripeCustomerId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    email = json['email'];
    phoneNum = json['phone'] ?? "";
    bio = json['bio'] ?? "";
    verified = json['verified'] ?? false;
    isHost = json['isHost'] ?? false;
    wallet = json['wallet'] ?? "";
    stripeCustomerId = json['stripeCustomerId'] ?? "";
    followersCount = json['followersCount'] ?? 0;
    followedCount = json['followedCount'] ?? 0;
    hostedEvenCount = json['hostedEvenCount'] ?? 0;
    profileImg = json['avatar'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['bio'] = bio;
    data['wallet'] = wallet;
    data['stripeCustomerId'] = stripeCustomerId;
    data['followersCount'] = followersCount;
    data['followedCount'] = followedCount;
    data['phoneNumber'] = phoneNum;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}
