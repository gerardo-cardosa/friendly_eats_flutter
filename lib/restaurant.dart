import 'package:flutter/material.dart';
import 'package:friendly_eats_flutter/restaurant_detail_route.dart';
import 'package:friendly_eats_flutter/rating_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';

class Restaurant extends StatelessWidget {
  //Restaurant properties
  final String title;
  final String city;
  final String category;
  final double avgRating;
  final int numRatings;
  final int price;
  final String photo;
  final String id;

  const Restaurant({
    Key key,
    @required this.title,
    @required this.city,
    @required this.category,
    @required this.avgRating,
    @required this.numRatings,
    @required this.photo,
    @required this.price,
    @required this.id,
  })  : assert(title != null),
        assert(city != null),
        assert(category != null),
        assert(avgRating != null),
        //assert(numRatings != null),
        assert(photo != null),
        assert(price != null)
 // assert(id != null);
;
  void _navigateToConverter(BuildContext context) {
    // TODO: Using the Navigator, navigate to the [ConverterRoute]
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return RestaurantDetailRoute(
        restaurant: this,
        stars: setStarts(null),
      );
    }));
  }

  List<Widget> setStarts(Color col) {
    print("Set Stars and rating: $avgRating");

    List<Widget> myList = new List<Widget>();
    for (int i = 1; i < avgRating; i++) {
      myList.add(Icon(Icons.star, color: col==null?Colors.black: col,));
     // myList.add(Icon(Icons.star));
    }

    int cinco = 5;
    if (avgRating.toInt() > 0 && avgRating / avgRating.toInt() > 0) {
      myList.add(Icon(Icons.star_half, color: col==null?Colors.black: col,));
      //myList.add(Icon(Icons.star));
      cinco--;
    }

    for (int i = avgRating.toInt(); i < cinco; i++) {
      myList.add(Icon(Icons.star_border, color: col==null?Colors.black: col,));
      //myList.add(Icon(Icons.star));
    }

    return myList;
  }



  @override
  Widget build(BuildContext context) {

    Future<String> getImage() async{
      //TODO: check if the image already exists and fetch that one
      //else make the call to storage


      final Directory tempDir = Directory.systemTemp;
      final File file = File('${tempDir.path}/$photo');
      final StorageReference ref = FirebaseStorage.instance.ref().child(photo);
      final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
      final int byteCount = (await downloadTask.future).totalByteCount;

      return file.path;
    }

    var storageFoto; 
    getImage().then((result){storageFoto = result; print(result);});
    



    return Material(
      color: Colors.transparent,
      child: Container(
        height: 100.0,
        child: InkWell(
          onTap: () {
            print('$title was tapped $id');
            _navigateToConverter(context);
          },
          child: Card(
            child: ListTile(
              leading: FlutterLogo(size: 30.0,),
//              Image(
//                image: new AssetImage(
//                  storageFoto
//                ),
//              ),
              title: Text(title),
              subtitle: new Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new StarRating(rating: avgRating),
                        Text("(" + numRatings.toString() + ")"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          category,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" - "),
                        Text(city)
                      ],
                    ),
                  ]
              ),
              trailing: (price == 1) ? Text('\$'): (price == 2) ? Text('\$\$'): Text('\$\$\$'),
              isThreeLine: true,
            ),
          ),
        ),
      ),
    );
  }
}
