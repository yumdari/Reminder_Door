import 'package:flutter/material.dart';

/* Clock */
import 'package:timer_builder/timer_builder.dart';
import 'package:date_format/date_format.dart';

/* Weather */
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apikey = '78875fa7b0b0cad43ec365684ab3eb1b';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reminder Door'),
        ),
        backgroundColor: Colors.grey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              //color: Colors.green,
              //padding: const EdgeInsets.all(6.0),
              child: TimerBuilder.periodic(
                const Duration(seconds: 1),
                builder: (context) {
                  return Text(
                    formatDate(DateTime.now(), [mm, "월  ", dd, "일  ", HH, " : ", nn]),
                    style: const TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Weather(),
              height: 100,
              color: Colors.red,
            ),
            Container(
              height: 350,
              color: Colors.blue,
            ),
          ],
        ));
  }
}

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  //double latitude2;
  //double longitude2;

  @override
  void initState(){
    super.initState();
    getLocation();
  }

  void getLocation() async{
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //latitude2 = position.latitude;
    //longitude2 = position.longitude;
    print(position);
    fetchData();
  }

  void fetchData() async {
    http.Response response = await http.get(
        Uri.parse('https://samples.openweathermap.org/data/2.5/weather?'
            'q=London&appid=b1b15e88fa797225412429c1c50c122a1'));
    if (response.statusCode == 200) { /* Connected */
      //print(response.body);
      String jsonData = response.body;
      //var myJson = jsonDecode(jsonData)['weather'][0]['description'];

      var temp = jsonDecode(jsonData)['main']['temp'];
      var desc = jsonDecode(jsonData)['weather'][0]['description'];
      print(temp);
      print(desc);

    }
    else{
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

