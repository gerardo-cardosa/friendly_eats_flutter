import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:friendly_eats_flutter/rating_bar.dart';

class Rating extends StatelessWidget {
  final double rating;
  final String text;
  final int timeStamp;
  final String userId;
  final String userName;

  const Rating({
    @required this.rating,
    @required this.text,
    @required this.timeStamp,
    @required this.userId,
    @required this.userName,
  })  : assert(rating != null),
        assert(text != null),
        //assert(timeStamp != null),
        assert(userId != null),
        assert(userName != null);

  @override
  Widget build(BuildContext context) {
    List<Widget> setStarts() {
      List<Widget> myList = new List<Widget>();
      for (int i = 1; i < rating; i++) {
        myList.add(Icon(Icons.star));
      }

      int cinco = 5;
      if (rating.toInt() > 0 && rating / rating.toInt() > 0) {
        myList.add(Icon(Icons.star_half));
        cinco--;
      }

      for (int i = rating.toInt(); i < cinco; i++) {
        myList.add(Icon(Icons.star_border));
      }

      return myList;
    }

    List<Widget> stars = setStarts();

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 100.0,
        child: InkWell(
          child: Card(
            child: ListTile(
              title: Text(userName,
                  style: new TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  )),
              subtitle: ListView(
                children: <Widget>[
                  Text(text,
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      )),
                ],
              ),
              isThreeLine: true,
            ),
            /*
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(userName,
                      style: new TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    )),
                    subtitle: Text(text,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                    )),
                  ),
                  //new StarRating(rating: rating),
                ],
              ),
            */
          ),
        ),
      ),
    );
  }
}
