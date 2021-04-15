class Item {
  int id;
  String description;
  String amount;
  String unity;
  int status; // 0 - Não Comprado, 1 - Comprado

  Item({this.description, this.amount, this.unity, this.status});
  Item.withId(
      {this.id, this.description, this.amount, this.unity, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = description;
    map['amount'] = amount;
    map['unity'] = unity;
    map['status'] = status;
    return map;
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item.withId(
        id: map['id'],
        description: map['description'],
        amount: map['amount'],
        unity: map['unity'],
        status: map['status']);
  }
}
