import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DatabaseManager{
  final CollectionReference profile = FirebaseFirestore.instance.collection('profile');

  Future<void>  createUserData(String name , String rollNumber , String uid) async{
    return await profile.doc(uid).set({
      'name': name,
      'rollNo' : rollNumber
    });
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await profile.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}