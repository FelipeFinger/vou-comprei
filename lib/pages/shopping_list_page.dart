import 'package:flutter/material.dart';
import 'package:voucomprei/helpers/database_helper.dart';
import 'package:voucomprei/models/item_model.dart';
import 'package:voucomprei/pages/add_item_page.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  Future<List<Item>> _itemList;

  @override
  void initState() {
    super.initState();
    _updateItemList();
  }

  _updateItemList() {
    setState(() {
      _itemList = DatabaseHelper.instance.getItemList();
    });
  }

  Widget _buildItem(Item item) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: <Widget>[
          ListTile(
            title: Text(
              item.description,
              style: TextStyle(
                  fontSize: 15.0,
                  decoration: item.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${item.amount} ${item.unity}',
              style: TextStyle(
                  fontSize: 10.0,
                  decoration: item.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                item.status = value ? 1 : 0;
                DatabaseHelper.instance.updateItem(item);
                _updateItemList();
              },
              activeColor: Theme.of(context).primaryColor,
              value: item.status == 1
            ),
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => AddItemPage(
                  updateItemList: _updateItemList,
                  item: item,
                ),
              )
            ),
          ),
          Divider()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddItemPage(
              updateItemList: _updateItemList,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _itemList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int completedItens = snapshot.data
              .where((Item item) => item.status == 1)
              .toList()
              .length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            itemCount: 1 + snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Lista de Compras',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '$completedItens de ${snapshot.data.length}',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ));
              }
              return _buildItem(snapshot.data[index - 1]);
            },
          );
        },
      ),
    );
  }
}
