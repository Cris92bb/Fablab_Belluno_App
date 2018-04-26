class Post {
  final int id;
  final String url;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String medThumb;
  final String publishDate;
  final String author;

  Post(
      {this.id,
      this.url,
      this.title,
      this.content,
      this.thumbnailUrl,
      this.medThumb,
      this.publishDate,
      this.author});

  factory Post.fromJson(Map<String, dynamic> json) {
    String thumb = json['thumbnail'];
    if (thumb != null) {
      final thumbs = json['thumbnail_images'];
      thumb = thumbs['medium_large']['url'];
    }

    String excerpt = json['excerpt'];
    excerpt = excerpt.substring(3);
    excerpt = excerpt.substring(0, excerpt.length - 5);

    String pDate = json['modified'];
    pDate = pDate.substring(0, 10);
    pDate = pDate.split('-').reversed.join('/');

    String authorName = json['author']['first_name'] != ""
        ? json['author']['first_name'] + " " + json['author']['last_name']
        : json['author']['name'];

    return new Post(
        title: json['title'],
        content: excerpt,
        url: json['url'],
        id: json['id'],
        thumbnailUrl: json['thumbnail'],
        medThumb: thumb,
        publishDate: pDate,
        author: authorName);
  }
}

class EventPost extends Post {
  final int id;
  final String url;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String time;
  final String geo;
  final String medThumb;
  final String publishDate;
  final String author;

  EventPost(
      {this.id,
      this.url,
      this.title,
      this.content,
      this.thumbnailUrl,
      this.time,
      this.geo,
      this.medThumb,
      this.publishDate,
      this.author});

  factory EventPost.fromJson(Map<String, dynamic> json) {
    final dateList = json['custom_fields']['data'];
    final coords = json['custom_fields']['luogo'];

    String time = '';
    if (dateList != null) {
      time = dateList[0];
      String yyyy = time.substring(0, 4);
      String mm = time.substring(4, 6);
      String dd = time.substring(6);
      time = dd + ' - ' + mm + ' - ' + yyyy;
    }
    String tempgc = '';
    if (coords != null) {
      tempgc = coords[0];
    }
    String thumb = json['thumbnail'];
    if (thumb != null) {
      final thumbs = json['thumbnail_images'];
      thumb = thumbs['medium_large']['url'];
    }
    String excerpt = json['excerpt'];
    excerpt = excerpt.substring(3);
    excerpt = excerpt.substring(0, excerpt.length - 5);
    String pDate = json['modified'];
    pDate = pDate.substring(0, 10);
    pDate = pDate.split('-').reversed.join('/');

    String authorName = json['author']['first_name'] != ""
        ? json['author']['first_name'] + " " + json['author']['last_name']
        : json['author']['name'];
    return new EventPost(
        time: time,
        title: json['title'],
        content: excerpt,
        url: json['url'],
        id: json['id'],
        thumbnailUrl: json['thumbnail'],
        medThumb: thumb,
        geo: tempgc,
        publishDate: pDate,
        author: authorName);
  }
}
