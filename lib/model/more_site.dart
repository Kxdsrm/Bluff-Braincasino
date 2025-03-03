class Moresite {
  String? image;
  double? rating;
  String? welcomeBonus;
  String? depositeBonus;
  String? url;

  Moresite({this.image, this.rating, this.welcomeBonus, this.depositeBonus});

  Moresite.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    rating = json['rating'];
    welcomeBonus = json['welcomeBonus'];
    depositeBonus = json['depositeBonus'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['rating'] = this.rating;
    data['welcomeBonus'] = this.welcomeBonus;
    data['depositeBonus'] = this.depositeBonus;
    data['url'] = this.url;
    return data;
  }
}