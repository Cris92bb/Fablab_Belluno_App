import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
