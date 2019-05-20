import 'package:flutter/material.dart';
import 'package:friendly_eats_flutter/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

final _backgroundColor = Colors.lightBlue[600];

class RestaurantRouter extends StatelessWidget{
  const RestaurantRouter();

  @override
  Widget build(BuildContext context) {
    final restaurants = <Restaurant>[];

    CachedNetworkImage getPhoto(String url) {
      print('Foto url: $url');
      return CachedNetworkImage(
        imageUrl: url,
        width: 70.0,
      );
    }

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
                  numRatings: int.parse(document['numRatings'].toString()),
                  photo: document['photo'].toString(),
                  price: document['price'],
                  id: document.documentID,
                  image: getPhoto(document['photo'].toString()),
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
            icon: const Icon(Icons.fastfood, color: Colors.white),
          );
        },
      ),

      elevation: 0.0,
      centerTitle: false,
      backgroundColor: _backgroundColor,
      title: Text(
        'Friendly Eats',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}