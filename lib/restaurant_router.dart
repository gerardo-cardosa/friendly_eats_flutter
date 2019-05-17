import 'package:flutter/material.dart';
import 'package:friendly_eats_flutter/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _backgroundColor = Colors.green[100];

class RestaurantRouter extends StatelessWidget{
  const RestaurantRouter();

  @override
  Widget build(BuildContext context) {
    final restaurants = <Restaurant>[];

    final query = StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('restaurants').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new Restaurant(
                  title: document['name'].toString(),
                  city: document['city'].toString(),
                  category: document['category'].toString(),
                  avgRating: document['avgRating'],
                  numRatings: document['numRating'],
                  photo: document['photo'].toString(),
                  price: document['price'],
                  id: document.documentID,
                );
              }).toList(),
            );
        }
      },
    );

    final listView = Container(
      child: query,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
    );

    final appBar = AppBar(

      leading: Builder(
        builder: (BuildContext context){
          return IconButton(
            icon: const Icon(Icons.fastfood),
          );
        },
      ),

      elevation: 0.0,
      centerTitle: false,
      backgroundColor: _backgroundColor,
      title: Text(
        'Friendly Eats',
        style: TextStyle(color: Colors.black, fontSize: 20.0),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}