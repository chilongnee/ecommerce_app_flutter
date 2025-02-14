class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? address;
  final String? linkImage;

  UserModel({required this.id, required this.email, required this.fullName, required this.address, this.linkImage}); 

    toJson(){
    return {
      "id" : id,
      "email" : email,
      "fullName": fullName,
      "address" : address,
      "imageLink" : linkImage
    };
  }
}