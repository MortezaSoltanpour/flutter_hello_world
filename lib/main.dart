import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/currency.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Currency> currency = [];
  String lastUpdated = "";
  String statusMessage = "";
  @override
  void initState() {
    super.initState();

    getResponse();
    lastUpdated = _getTime(); // initial time
  }

  String _getTime() {
    return "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
  }

  void _refreshTime() {
    setState(() {
      lastUpdated = _getTime();
      final now = DateTime.now();
      final formattedTime =
          "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
      statusMessage = "Latest update: $formattedTime";
    });
  }

  clearList() {
    currency.clear();
  }

  Future getResponse() async {
    setState(() {
      statusMessage = "Getting data...";
    });
    print("Calling api");
    developer.log("Calling api", name: 'my.app.category');
    String url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        currency = jsonResponse.map((item) {
          return Currency(
            id: item["id"],
            title: item["title"],
            changes: item["changes"],
            price: item["price"],
            status: item["status"],
          );
        }).toList();
      });
      _showSnackMessage(context, "Data refreshed!");
      _refreshTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    // getResponse();

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
                            clearList();
                            getResponse();
                          },
                          child: Row(
                            children: [
                              Text("Refresh"),
                              SizedBox(width: 5),
                              Icon(Icons.refresh),
                            ],
                          ),
                        ),
                        if (statusMessage == "Getting data...")
                          CircularProgressIndicator(color: Colors.pink),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(statusMessage),
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
                Text(
                  currencyItem.changes,
                  style: TextStyle(
                    color: currencyItem.status == "p"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
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
