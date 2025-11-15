class User {
  String? userId;
  String? userEmail;
  String? userPassword;
  String? userName;
  String? userPhone;
  String? userOtp;
  String? userRegdate;

  User({
    this.userId,
    this.userEmail,
    this.userPassword,
    this.userName,
    this.userPhone,

    this.userOtp,
    this.userRegdate,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userOtp = json['user_otp'];
    userRegdate = json['user_regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_password'] = userPassword;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['user_otp'] = userOtp;
    data['user_regdate'] = userRegdate;
    return data;
  }
}
