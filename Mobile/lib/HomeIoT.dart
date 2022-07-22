import 'package:flutter/material.dart';

import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class HomeIoT extends StatefulWidget {
  const HomeIoT({Key? key}) : super(key: key);

  @override
  State<HomeIoT> createState() => _HomeIoTState();
}

class _HomeIoTState extends State<HomeIoT> {

  String message="";

  int temp = 0;
  int humi = 0;

  String strTemp = '';
  String strHumi = '';

  static bool isConnected = false;

  TcpSocketConnection socketConnection=TcpSocketConnection("10.10.141.43", 5000);

  /* 페이지 열리면서 바로 실행 */
  @override
  void initState(){
    super.initState();
    if(!isConnected) {
      connectToServer();
      isConnected = !isConnected; // 오직 1번만 실행하기 위해 플래그변수 변경
    }
  }

  void sendMessage(String msg){
    socketConnection.sendMessage(msg);
  }

  //receiving and sending back a custom message
  void messageReceived(String msg){
    int msgLen = msg.length; // 문자열 길이 확인
    print(msgLen);
    if(msgLen != 20) {
      return;
    }
    var listSensorVal = msg.split('@');
    strTemp = listSensorVal[0];
    strHumi = listSensorVal[1];

    print('splitted temp : ' + strTemp);
    //if(msgLen)
    //var list = valueFromRasp
    setState(() {

      //print('splitted temp : ' + strTemp);

      //print('splitted humi : ' + strHumi);
      //temp = int.parse(listSensorVal[0]);
      //humi = int.parse(listSensorVal[1]);

      message=msg;
    });
    //socketConnection.sendMessage("MessageIsReceived :D ");
  }

  //starting the connection and listening to the socket asynchronously
  void connectToServer() async{
    socketConnection.enableConsolePrint(true);    //use this to see in the console what's happening
    if(await socketConnection.canConnect(5000, attempts: 1)){   //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Recevied message : ' + message,
          ),
          Text('temp : ' + strTemp),
          Text('humi : ' + strHumi),
          ElevatedButton(onPressed: (){sendMessage('hello, first message');}, child: Text('Send'))
        ],
      ),
    );
  }
}