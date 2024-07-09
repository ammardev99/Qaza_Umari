import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:qaza_e_umri/models/load_monthly_qaza.dart';
import 'package:qaza_e_umri/models/load_umari_qaza.dart';
import 'package:qaza_e_umri/models/nimaz.dart';

class MonthEndTest extends StatefulWidget {
  const MonthEndTest({super.key});

  @override
  State<MonthEndTest> createState() => _MonthEndTestState();
}

class _MonthEndTestState extends State<MonthEndTest> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    await loadMonthlyQazaRecord();
    SetQazaUmariRecord();
    setState(() {
      isLoading = false;
    });
  }

  void _refreshData() {
    _loadData();
  }

  // ignore: unused_element
  Future<void> _sendNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if (token != null) {
      final url = Uri.parse(
          'https://<your-cloud-function-url>/sendMonthEndNotification?token=$token');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notification sent')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send notification')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending notification: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              children: [
                Column(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          showTValue('Type'),
                          showTValue('Fajar'),
                          showTValue('Zohar'),
                          showTValue('Asar'),
                          showTValue('Maghrib'),
                          showTValue('Isha'),
                          showTValue('Witr'),
                        ]),
                        TableRow(children: [
                          showTValue('Monthly Qaza'),
                          showTValue('${TestMonthlyQazaNimazRecord.Fajar}'),
                          showTValue('${TestMonthlyQazaNimazRecord.Zoher}'),
                          showTValue('${TestMonthlyQazaNimazRecord.Asr}'),
                          showTValue('${TestMonthlyQazaNimazRecord.Maghrib}'),
                          showTValue('${TestMonthlyQazaNimazRecord.Isha}'),
                          showTValue('${TestMonthlyQazaNimazRecord.Witer}'),
                        ]),
                        TableRow(children: [
                          showTValue('Total Qaza'),
                          showTValue('${TestQazaUmariNimazRecord.Fajar}'),
                          showTValue('${TestQazaUmariNimazRecord.Zoher}'),
                          showTValue('${TestQazaUmariNimazRecord.Asr}'),
                          showTValue('${TestQazaUmariNimazRecord.Maghrib}'),
                          showTValue('${TestQazaUmariNimazRecord.Isha}'),
                          showTValue('${TestQazaUmariNimazRecord.Witer}'),
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.green),
                          ),
                          onPressed: () {
                            setState(() {
                              addMonthlyToQazaUmari();
                            });
                          },
                          child: Text(
                            "Month End",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _refreshData,
                          child: Text("Undo"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // ElevatedButton(
                    //   onPressed: _sendNotification,
                    //   child: Text('Send Notification'),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

Widget showTValue(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text),
  );
}

void main() {
  runApp(MaterialApp(
    home: MonthEndTest(),
  ));
}
