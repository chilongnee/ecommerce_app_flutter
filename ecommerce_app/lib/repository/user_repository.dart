import 'dart:typed_data';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(BuildContext context, UserModel user) async {
    try {
      await _db.collection("users").add(user.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account has been created."),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (error, stackTrace) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Please try again!"),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }


  Future<UserModel?> getUserDetails(String id) async {
  final snapshot = await _db.collection("users").where("id", isEqualTo: id).get();

  if (snapshot.docs.isNotEmpty) {
    final data = snapshot.docs.first.data();
    
    if (data != null && data.isNotEmpty) {
       snapshot.docs.forEach((doc) {
        print(doc.data());
      }); 

      return UserModel(
        id: data["id"] ?? "", 
        email: data["email"] ?? "",
        fullName: data["fullName"] ?? "", 
        address: data["address"] ?? "",
        linkImage: data["linkImage"] ?? "",
      );
    } else {
      print("Dữ liệu người dùng rỗng hoặc không tồn tại");
      return null;
    }
  } else {
    print("Không tìm thấy tài liệu người dùng với ID: $id");
    return null;
  }
}






}
