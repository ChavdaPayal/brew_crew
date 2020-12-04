import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {
  final String uid;
  DatabaseService ({this.uid});

  //collection reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');
  Future updateUserData(String suger,String name,int strength) async{
    return await brewCollection.document(uid).setData({
      'suger' : suger,
      'name' : name,
      'strength':strength,
    });
  }
  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
    return Brew(
      name: doc.data['name'] ?? '',
      strength: doc.data['strength'] ?? 0,
      suger: doc.data['suger'] ?? '0',
      );
    }).toList();
  }
  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      suger: snapshot.data['suger'],
      strength: snapshot.data['strength'],
    );
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
}

   