import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage(this.uri);

  final String uri;

  @override
  Widget build(BuildContext context) {
    if (uri != null) {
      return new ClipOval(
          child: new Image.network(uri, height: 50.0, fit: BoxFit.cover));
    } else {
      return new ClipOval(
          child: new Image.asset('images/fablogo.png',
              height: 50.0, fit: BoxFit.cover));
    }
  }
}

class CoverImage extends StatelessWidget {
  final String uri;

  const CoverImage(this.uri);

  @override
  Widget build(BuildContext context) {
    if (uri != null) {
      return new Image.network(
        uri,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery
            .of(context)
            .size
            .height / 3, //altezza massima 1/3 dello schermo
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    } else {
      return new Image.asset(
        'images/fablogo.bmp',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    }
  }
}

class CustomButton extends StatelessWidget {
  final color = Colors.deepOrange;
  final IconData icon;
  final String label;

  const CustomButton(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Icon(icon, color: color),
        new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            )),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
            children: <Widget>[
              new DrawerHeader(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                    boxShadow: [new BoxShadow(
                      color: Colors.deepOrangeAccent,
                      blurRadius: 10.0,
                    ),
                    ]
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Image.asset(
                      "images/fablogo.png",
                      width: 100.0,
                    ),
                    new Text(
                      "Fablab Belluno",
                      style: new TextStyle(fontSize: 20.0, color: Colors.white),
                    )
                  ],
                ),
              ),
              new ListTile(
                title: new Text("Seguici su"),
                onTap: null,
              ),
              new ListTile(
                leading: new Icon(
                  FontAwesomeIcons.facebook, color: Colors.deepOrange,),
                title: new Text("Facebook"),
                onTap: () async {
                  launch("https://www.facebook.com/FabLabBelluno/");
                },
              ),
              new ListTile(
                leading: new Icon(
                    FontAwesomeIcons.twitter, color: Colors.deepOrange),
                title: new Text("Twitter"),
                onTap: () async {
                  launch("https://twitter.com/fablabimpresa");
                },
              ),
              new ListTile(
                leading: new Icon(
                    FontAwesomeIcons.instagram, color: Colors.deepOrange),
                title: new Text("Instagram"),
                onTap: () async {
                  launch("https://www.instagram.com/fablabelluno/");
                },
              ),
              new Divider(),
              new Container(
                alignment: Alignment.bottomRight,
                padding: new EdgeInsets.all(20.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      new Text(
                        "Versione 1.5",
                        style: new TextStyle(color: Colors.grey),
                      )
                    ]),
              )
            ]
        )
    );
  }

}
