import 'package:flutter/material.dart';
import 'package:voucomprei/helpers/database_helper.dart';
import 'package:voucomprei/models/item_model.dart';

class AddItemPage extends StatefulWidget {
  final Function updateItemList;
  final Item item;

  AddItemPage({this.updateItemList, this.item});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _amount = '';
  String _unity;

  final List<String> _units = [
    'Unidades (Un)',
    'Quilogramas (Kg)',
    'Litros (L)'
  ];

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      _description = widget.item.description;
      _amount = widget.item.amount;
      _unity = widget.item.unity;
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteItem(widget.item.id);
    widget.updateItemList();
    Navigator.pop(context);
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_description, $_amount, $_unity');

      Item item =
          Item(description: _description, amount: _amount, unity: _unity);
      if (widget.item == null) {
        item.status = 0;
        DatabaseHelper.instance.insertItem(item);
      } else {
        item.id = widget.item.id;
        item.status = widget.item.status;
        DatabaseHelper.instance.updateItem(item);
      }

      widget.updateItemList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 30.0,
                  color: Theme.of(context).primaryColor,
                )),
            SizedBox(
              height: 20.0,
            ),
            Text(
              widget.item == null ? 'Adicionar Item' : 'Editar Item',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                          labelText: 'Descri????o',
                          labelStyle: TextStyle(fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (input) => input.trim().isEmpty
                          ? 'Informe a descri????o do item!'
                          : null,
                      onSaved: (input) => _description = input,
                      initialValue: _description,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                          labelText: 'Quantidade',
                          labelStyle: TextStyle(fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (input) =>
                          input.trim().isEmpty ? 'Informe a quantidade!' : null,
                      onSaved: (input) => _amount = input,
                      initialValue: _amount,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: DropdownButtonFormField(
                      isDense: true,
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconSize: 20.0,
                      iconEnabledColor: Theme.of(context).primaryColor,
                      items: _units.map((String unity) {
                        return DropdownMenuItem(
                          value: unity,
                          child: Text(
                            unity,
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                          ),
                        );
                      }).toList(),
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                          labelText: 'Unidade',
                          labelStyle: TextStyle(fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (input) => _unity == null
                          ? 'Selecione a unidade a ser considerada!'
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _unity = value;
                        });
                      },
                      value: _unity,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: FlatButton(
                      child: Text(
                        widget.item == null ? 'Adicionar' : 'Editar',
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      onPressed: _submit,
                    ),
                  ),
                  widget.item != null
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: FlatButton(
                            child: Text(
                              'Apagar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                            onPressed: _delete,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      )),
    ));
  }
}
