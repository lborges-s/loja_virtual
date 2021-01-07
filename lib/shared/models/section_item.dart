class SectionItem {
  SectionItem({this.image, this.product});

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'] as String;
    product = map['product'] as String;
  }

  Map<String, dynamic> toMap() => {
        'image': image,
        'product': product,
      };

  dynamic image;
  String product;

  SectionItem clone() {
    return SectionItem(
      image: image,
      product: product,
    );
  }
}
