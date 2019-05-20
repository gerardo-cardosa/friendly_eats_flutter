import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:friendly_eats_flutter/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendly_eats_flutter/restaurant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RestaurantDetailRoute extends StatelessWidget {
//  final String title;
//  final String id;
//  final double avgRating;
//  final String city;
//  final String category;
//  final String price;
  final Restaurant restaurant;
  final List<Widget> stars;

  const RestaurantDetailRoute({
//    @required this.title,
//    @required this.id,
@required this.restaurant,
    @required this.stars
  });

  @override
  Widget build(BuildContext context) {
    print(
        "This is the query 'restaurants/$restaurant.id/ratings' this is the title: $restaurant ");
    print(restaurant.title);

    String id = restaurant.id;


    final query = StreamBuilder<QuerySnapshot>(
      stream:
          Firestore.instance.collection('restaurants/$id/ratings').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new Rating(
                  rating: document['rating'].toDouble(),
                  text: document['text'].toString(),
                  timeStamp: document['timeStamp'],
                  userId: document['UserId'].toString(),
                  userName: document['userName'].toString(),
                );
              }).toList(),
            );
        }
      },
    );

    final listView = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Container(
            constraints: new BoxConstraints.expand(
              height: 200.0,
            ),
            padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: CachedNetworkImageProvider(restaurant.photo),
                fit: BoxFit.cover,
              ),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  left: 0.0,
                  bottom: 40.0,
                  child: new Text(restaurant.title,
                      style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ),
                new Positioned(
                  left: 0.0,
                  bottom: 20.0,
                  child:
                  Row(
                    children: restaurant.setStarts(Colors.white),
                  )
                ),
                new Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: new Text(restaurant.category + ' - ' + restaurant.city,
                      style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      )),
                ),
                new Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: (restaurant.price == 1) ? Text('\$'): (restaurant.price == 2) ? Text('\$\$'): Text('\$\$\$'),
                ),
              ],
            )),
        Expanded(
          flex: 1,
          child: query,
        ),
      ],
    );

    final appBar = AppBar(
      elevation: 0.0,
      title: Text(
        "Nein",
        style: TextStyle(color: Colors.black, fontSize: 10.0),
      ),
      centerTitle: true,
      //backgroundColor: _backgroundColor,
    );

    return Scaffold(
      //appBar: appBar,
      body: listView,
    );
  }
}
