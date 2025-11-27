import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/currency.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  List<Currency> currency = [];

  getResponse() {
    String url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        List jsonResponse = convert.jsonDecode(response.body);

        jsonResponse.map((item) {
          currency.add(
            Currency(
              id: item["id"],
              title: item["title"],
              changes: item["changes"],
              price: item["price"],
              status: item["status"],
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currency = _addSampleData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/images/icon.png", fit: BoxFit.contain),
          ),
          title: Text(
            "This is my app",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/bus.png"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Color.fromARGB(255, 240, 240, 240),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("This is main title"),
                      SizedBox(width: 8),
                      Image.asset("assets/images/icon.png", height: 30),
                    ],
                  ),
                  Text(
                    "Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume Lorem ipsume ",
                  ),
                  MyTable(),

                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),

                      itemBuilder: (context, index) =>
                          MyTableRow(currency[index]),
                      itemCount: currency.length,
                      separatorBuilder: (BuildContext context, int index) {
                        if (index % 7 == 0 && index > 0) {
                          debugPrint("Row is going!");
                          return MyAdRow();
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,

                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Rounded corners
                            ),
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            _showSnackMessage(context, "Data refreshed!");
                          },
                          child: Row(
                            children: [
                              Text("Refresh"),
                              SizedBox(width: 5),
                              Icon(Icons.refresh),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text("Last updated: ${_getTime()}"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Currency> _addSampleData() {
  List<Currency> new_currency = [];

  new_currency.add(
    Currency(
      id: "1",
      title: "USD",
      changes: "+1.0",
      price: "100.0",
      status: "p",
    ),
  );
  new_currency.add(
    Currency(
      id: "2",
      title: "Euro",
      changes: "-2.0",
      price: "200.0",
      status: "p",
    ),
  );
  new_currency.add(
    Currency(
      id: "3",
      title: "CAD",
      changes: "+1.2",
      price: "25.0",
      status: "p",
    ),
  );
  new_currency.add(
    Currency(
      id: "4",
      title: "JWU",
      changes: "+9.0",
      price: "54.0",
      status: "p",
    ),
  );
  new_currency.add(
    Currency(
      id: "5",
      title: "LAO",
      changes: "-1.3",
      price: "123.0",
      status: "p",
    ),
  );
  new_currency.add(
    Currency(
      id: "6",
      title: "JDU",
      changes: "+1.4",
      price: "980.0",
      status: "p",
    ),
  );

  return new_currency;
}

String _getTime() {
  return "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
}

void _showSnackMessage(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 16.0,
  );
  print(message);
  // ScaffoldMessenger.of(context).showMaterialBanner(
  //   MaterialBanner(
  //     content: Text("Data refreshed!"),
  //     backgroundColor: Colors.green,
  //     actions: [
  //       TextButton(
  //         onPressed: () =>
  //             ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
  //         child: Text("DISMISS"),
  //       ),
  //     ],
  //   ),
  // );
}

class MyTable extends StatelessWidget {
  const MyTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Currency", style: TextStyle(color: Colors.white)),
            Text("Price", style: TextStyle(color: Colors.white)),
            Text("Change", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class MyTableRow extends StatelessWidget {
  final Currency currencyItem;
  MyTableRow(this.currencyItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,

            // border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currencyItem.title),
                Text(currencyItem.price),
                Text(currencyItem.changes),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 0),
          child: Container(
            height: 1,
            color: Colors.grey,
            width: double.infinity - 40,
          ),
        ),
      ],
    );
  }
}

class MyAdRow extends StatelessWidget {
  const MyAdRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),

      child: Text(
        "This is ad",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
