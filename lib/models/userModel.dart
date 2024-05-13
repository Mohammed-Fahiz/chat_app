class UserModel {
  String? userId;
  String name;
  String userPhoneNo;
  String email;
  String fcmToken;
  String? userImage;

//<editor-fold desc="Data Methods">
  UserModel({
    this.userId,
    required this.name,
    required this.userPhoneNo,
    required this.email,
    required this.fcmToken,
    this.userImage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          userPhoneNo == other.userPhoneNo &&
          email == other.email &&
          fcmToken == other.fcmToken &&
          userImage == other.userImage);

  @override
  int get hashCode =>
      userId.hashCode ^
      name.hashCode ^
      userPhoneNo.hashCode ^
      email.hashCode ^
      fcmToken.hashCode ^
      userImage.hashCode;

  @override
  String toString() {
    return 'UserModel{ userId: $userId, name: $name, userPhoneNo: $userPhoneNo, email: $email, fcmToken: $fcmToken, userImage: $userImage,}';
  }

  UserModel copyWith({
    String? userId,
    String? name,
    String? userPhoneNo,
    String? email,
    String? fcmToken,
    String? userImage,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      userPhoneNo: userPhoneNo ?? this.userPhoneNo,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      userImage: userImage ?? this.userImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'userPhoneNo': userPhoneNo,
      'email': email,
      'fcmToken': fcmToken,
      'userImage': userImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      name: map['name'] as String,
      userPhoneNo: map['userPhoneNo'] as String,
      email: map['email'] as String,
      fcmToken: map['fcmToken'] as String,
      userImage: map['userImage'] as String,
    );
  }

//</editor-fold>
}
