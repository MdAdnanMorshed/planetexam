class NewProductModel {
  var id;
  var name;
  var thumbnailImage;
  var basePrice;
  var baseDiscountedPrice;
  var discount;
  var discountType;

  NewProductModel(
      {this.id,
        this.name,
        this.thumbnailImage,
        this.basePrice,
        this.baseDiscountedPrice,
        this.discount,
        this.discountType});

  NewProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnailImage = json['thumbnail_image'];
    basePrice = json['base_price'];
    baseDiscountedPrice = json['base_discounted_price'];
    discount = json['discount'];
    discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnail_image'] = this.thumbnailImage;
    data['base_price'] = this.basePrice;
    data['base_discounted_price'] = this.baseDiscountedPrice;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    return data;
  }
}


