import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:html_unescape/html_unescape.dart';

import 'CustomWidgets.dart';
import 'Helpers.dart';

void main() => runApp(new MyApp());

//Starting Activity
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fablab Belluno',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new FLHome(), //home screen
    );
  }
}

//Main Page
class FLHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //cover image Widget
    Widget coverImage = new Image.asset(
      'images/fablogo.bmp',
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.contain,
    );
    //Title widget
    Widget title = new Container(
        padding: EdgeInsets.all(32.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new Text(
                'Fablab Belluno',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new Text(
              'Dove le idee diventano realta\'',
              style: new TextStyle(
                color: Colors.grey[500],
              ),
            )
          ],
        ));

    //Article list
    Widget posts = new ListTile(
      title: new Text('Articoli'),
      trailing: new Icon(
        Icons.arrow_forward,
        color: Colors.deepOrange,
      ),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new Articles()),
        );
      },
    );

    //Events List Tile
    Widget events = new ListTile(
      title: new Text('Eventi'),
      trailing: new Icon(
        Icons.arrow_forward,
        color: Colors.deepOrange,
      ),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new Events()),
        );
      },
    );


    //Row with buttons
    Widget buttons = new Container(
      alignment: AlignmentDirectional.bottomCenter,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new GestureDetector(
            child: new CustomButton(Icons.phone, 'Chiama'),
            onTap: () async {
              await launch("tel://0437851357");
            },
          ),
          new GestureDetector(
            child: new CustomButton(Icons.mail, 'Scrivici'),
            onTap: () async {
              await launch("mailto:fablab@centroconsorzi.it");
            },
          ),
          new GestureDetector(
            child: new CustomButton(Icons.directions, 'Indicazioni'),
            onTap: () async {
              await launch("geo:0,0?q=Fablab Belluno");
            },
          ),
          new GestureDetector(
            child: new CustomButton(Icons.web, 'Sito Web'),
            onTap: () async {
              await launch("http://fablab.centroconsorzi.it/");
            },
          )
        ],
      ),
    );

    // Implementation of the main page
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Fablab Belluno'),
        ),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  coverImage,
                  title,
                  posts,
                  events,
                ],
              ),
              new Container(
                padding: EdgeInsets.only(bottom: 10.0),
                alignment: Alignment.bottomCenter,
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[buttons]),
              ),
            ]));
  }
}

//Articles page
class Articles extends StatelessWidget {
  final uri = 'http://fablab.centroconsorzi.it/api/';

  @override
  Widget build(BuildContext context) {
    //getting recent post from the website
    Future<FLResponse> fetchRecent() async {
      final response = await http.get(uri + '/get_recent_posts/');
      final responseJson = json.decode(response.body);
      return new FLResponse.fromJson(responseJson);
    }

    //creating lists from the json
    Widget articlesList = new FutureBuilder<FLResponse>(
        future: fetchRecent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
              itemBuilder: (BuildContext context, int index) => new PostItem(
                  snapshot.data.posts[index]), // building listails from data
              itemCount: snapshot.data.count, // how mouch post we have
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Center(child: new CircularProgressIndicator());
        });
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Articoli'),
        ),
        body: articlesList);
  }
}

// articles classes ===============================================
//Single row from Article list
class PostItem extends StatelessWidget {
  const PostItem(this.post); //creating from poassing a Post object
  final Post post;

  @override
  Widget build(BuildContext context) {
    Widget _buildTiles(Post root) {
      var unescape = new HtmlUnescape();
      return new ExpansionTile(
          title: new Row(
            children: <Widget>[
              new ThumbnailImage(post.thumbnailUrl),
              new Expanded(
                  child: new Container(
                      margin: new EdgeInsets.only(left: 20.0),
                      child: new Text(post.title))),
            ],
          ),
          key: new PageStorageKey(post.id),
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(post.author,
                        style: new TextStyle(color: Colors.grey[700])),
                  ),
                  new Expanded(
                      child: new Text(post.publishDate,
                          textAlign: TextAlign.end,
                          style: new TextStyle(color: Colors.grey[700])))
                ],
              ),
            ),
            new Container(
              //post description
              padding: new EdgeInsets.all(20.0),
              child: new Text(unescape.convert(post.content), softWrap: true),
            ),
            new ListTile(
              title: new Text(
                'Approfondisci',
                style: new TextStyle(color: Colors.grey),
              ),
              trailing: new Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SingleArticle(post)),
                );
              },
            )
          ]);
    }
    return _buildTiles(post);
  }
}

class FLResponse {
  final String status;
  final int count;
  final int countTotal;
  final List<Post> posts;
  final List<EventPost> eventposts;
  FLResponse(
      {this.status, this.count, this.countTotal, this.posts, this.eventposts});
  factory FLResponse.fromJson(Map<String, dynamic> json) {
    final int count = json['count'];
    final List<Post> plist = [];
    for (int i = 0; i < count; i++) {
      plist.add(Post.fromJson(json['posts'][i]));
    }
    return new FLResponse(
        status: json['status'],
        count: json['count'],
        countTotal: json['count_total'],
        posts: plist
    );
  }

  factory FLResponse.fromEventJson(Map<String, dynamic> json) {
    final int count = json['count'];
    final List<EventPost> plist = [];
    for (int i = 0; i < count; i++) {
      plist.add(EventPost.fromJson(json['posts'][i]));
    }
    return new FLResponse(
        status: json['status'],
        count: json['count'],
        countTotal: json['count_total'],
        eventposts: plist);
  }
}



//SINGLE article page

class SingleArticle extends StatelessWidget {
  final Post post;

  const SingleArticle(this.post); //creating from poassing a Post object
  @override
  Widget build(BuildContext context) {
    Row buttons = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new GestureDetector(
            child: new CustomButton(Icons.web, 'Leggi Tutto'),
            onTap: () async {
              await launch(post.url);
            },
          ),
          new GestureDetector(
            child: new CustomButton(Icons.share, 'Condividi'),
            onTap: () async {
              await share(post.url);
            },
          )
        ]);

    var unescape = new HtmlUnescape();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(post.title),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new ClipPath(child: new CoverImage(post.medThumb),
                clipper: new BottomWaveClipper()),
            new Container(
              child: new Text(
                post.title,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
            new Container(
                padding: EdgeInsets.all(20.0),
                child: new Text(unescape.convert(post.content))),
            new Container(
              padding: new EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      post.author,
                      style: new TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  new Expanded(
                      child: new Text(
                        post.publishDate,
                        textAlign: TextAlign.end,
                        style: new TextStyle(color: Colors.grey[700]),
                      )
                  ),
                ],
              ),
            ),
            new Container(
                alignment: Alignment.bottomCenter,
                padding: new EdgeInsets.only(bottom: 20.0),
                child: buttons),
          ],
        ),
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    // Draw a straight line from current point to the bottom left corner.
    path.lineTo(0.0, size.height - 20);
    // Draw a straight line from current point to the top right corner.
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    // Draws a straight line from current point to the first point of the path.
    // In this case (0, 0), since that's where the paths start by default.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
//------------------------------Single article -----------------

//articles helper ends ==============================================


class Events extends StatelessWidget {
  final uri = 'http://fablab.centroconsorzi.it/api/';

  @override
  Widget build(BuildContext context) {
    Future<FLResponse> fetchRecent() async {
      final response = await http.get(uri + '/get_category_posts/?slug=eventi');
      final responseJson = json.decode(response.body);
      return new FLResponse.fromEventJson(responseJson);
    }

    Widget response = new FutureBuilder<FLResponse>(
        future: fetchRecent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  new EventPostItem(snapshot.data.eventposts[index]),
              itemCount: snapshot.data.count,
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Center(child: new CircularProgressIndicator());
        });
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Eventi - Fablab'),
        ),
        body: response);
  }
}

//------------------------------- events getter



class EventPostItem extends StatelessWidget {
  const EventPostItem(this.post);
  final EventPost post;

  @override
  Widget build(BuildContext context) {
    Widget _buildTiles(EventPost root) {
      return new ExpansionTile(
          title: new Row(
            children: <Widget>[
              new ThumbnailImage(post.thumbnailUrl),
              new Expanded(
                  child: new Container(
                margin: new EdgeInsets.only(left: 20.0),
                child: new Text(post.title),
              )),
            ],
          ),
          key: new PageStorageKey(post.id),
          children: <Widget>[
            new GestureDetector(
              child: new Container(
                padding: new EdgeInsets.all(20.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                        post.time,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      trailing: new Icon(Icons.timer),
                    ),
                    new ListTile(
                      title: new Text(post.geo,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey)),
                      trailing: new Icon(Icons.directions),
                      onTap: () {
                        launch('geo:0,0?q=' + post.geo);
                      },
                    ),
                    new ListTile(
                        title: new Text(
                          'Descrizione',
                          style: new TextStyle(color: Colors.deepOrange),
                        ),
                        trailing: new Icon(
                          Icons.arrow_forward,
                          color: Colors.deepOrange,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SingleArticle(post)),
                          );
                        })
                  ],
                ),
              ),
            )
          ]);
    }
    return _buildTiles(post);
  }
}
