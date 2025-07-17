class ItemModel {
  String desc;
  int qty;
  double rate;
  ItemModel({ required this.desc, required this.qty, required this.rate });

  double get total => qty * rate;
}
