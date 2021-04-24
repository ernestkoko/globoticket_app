import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'myLocalizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => MyLocalizations.of(context).title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        const MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('de', ''),
        const Locale('he', ''),
      ],
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalizations.of(context).title),
      ),
      body: OrderForm(),
    );
  }
}

class OrderForm extends StatefulWidget {
  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller;
  double _ticketPrice = 0;
  int _amount = 0;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> _categories = {
      'Standing': 33.33,
      'Upper Level': 44.44,
      'Lower Level': 55.55,
    };

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image(image: AssetImage('assets/logo.png')),
              TextFormField(
                controller: _controller,
                decoration: new InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  labelText: MyLocalizations.of(context).find('eventdate-label'),
                  hintText: MyLocalizations.of(context).find('eventdate-hint'),
                ),
                keyboardType: TextInputType.datetime,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(new Duration(days: 31)),
                  ).then((value) {
                    _controller.text = value.toString().substring(0, 10);
                  });
                },
              ),
              DropdownButtonFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.event_seat_outlined),
                    labelText: MyLocalizations.of(context).find('category-label'),
                    hintText: MyLocalizations.of(context).find('category-hint'),
                  ),
                  items: _categories
                      .map((name, price) {
                        return MapEntry(
                            name,
                            DropdownMenuItem(
                              value: price,
                              child: Text('$name (\$$price)'),
                            ));
                      })
                      .values
                      .toList(),
                  onChanged: (value) {
                    _ticketPrice = value;
                  }),
              TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.confirmation_number),
                    labelText: MyLocalizations.of(context).find('amount-label'),
                    hintText: MyLocalizations.of(context).find('amount-hint'),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    _amount = int.tryParse(value) ?? 0;
                  }),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RaisedButton(
                      child: Text(MyLocalizations.of(context).find('order')),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                MyLocalizations.of(context).find('confirmation')
                                    .replaceAll('XXX', _amount.toString())
                                    .replaceAll('YYY', (_amount * _ticketPrice).toString())
                            ),
                          ));
                        }
                      })),
            ],
          ),
        ));
  }
}
