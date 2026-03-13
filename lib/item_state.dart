class ItemState {
  String name;
  int qty;

  ItemState({required this.name, required this.qty});

  ItemState copy() => ItemState(name: name, qty: qty);
}
