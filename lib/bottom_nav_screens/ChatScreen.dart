import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickfit/model/MessageModel.dart';
import 'package:quickfit/model/User.dart';

class ChatScreen extends StatefulWidget {
  User user;

  ChatScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<List> _future;
  var messageController = new TextEditingController();
  List<MessageModel> chatList = <MessageModel>[];
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 9999);

  void initState() {
    // TODO: implement initState
    super.initState();
    getChat();
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onTap: () {
                if (chatList.isNotEmpty) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              controller: messageController,
              decoration: InputDecoration.collapsed(
                  hintText: 'Send a message..',
                  hintStyle: TextStyle(fontSize: 18)),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Color(0xFFC11010),
            onPressed: () {
              if (chatList.isNotEmpty) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
              setState(() {
                if (messageController.text != '') {
                  MessageModel userMessage =
                      MessageModel(messageController.text.toString(), false);
                  chatList.add(userMessage);
                  uploadMessage(messageController.text.toString());
                  messageController.clear();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: AppBar(
            leading: IconButton(
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
            ),
            elevation: 1.65,
            backgroundColor: Color(0xFFC11010).withOpacity(0.8),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Image.asset(
                  'assets/images/quickFitColored.png',
                  height: 100,
                  width: 200,
                  fit: BoxFit.fill
              ),
            ),
            shadowColor:Color(0xFFC11010),
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/offersBG.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO Chat HERE
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/personIMG.png',
                        height: 50,
                      ),
                      Text(
                        'ADMIN',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text('24/7 Customer Support.')
                    ],
                  ),
                ),
                chatList.isNotEmpty
                    ? Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(5),
                    itemCount: chatList.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (chatList[index].admin == false) {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width *
                                      0.80,
                                ),
                                padding: EdgeInsets.all(10),
                                margin:
                                EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFC11010),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  chatList[index].message,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width *
                                      0.80,
                                ),
                                padding: EdgeInsets.all(10),
                                margin:
                                EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  chatList[index].message,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                )
                    : Center(
                  child: Text(
                    'Start Conversation Now!',
                    style: TextStyle(
                        color: Color(0xFFC11010),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _sendMessageArea(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  getChat() async {
    chatList.clear();
    String URL =
        'http://sania.co.uk/quick_fix/chat/MyData.php?id=${widget.user.id}';
    http.Response response = await http.get(URL);
    List test = json.decode(response.body);
    for (var i = 0; i < test.length; i++) {
      MessageModel message = MessageModel(test[i]['msg'], test[i]['admin']);
      setState(() {
        chatList.add(message);
      });
    }
  }

  void uploadMessage(String string) async{

    // UPLOADING MESSAGE USING POST METHOD

    String URL = 'http://sania.co.uk/quick_fix/chat/Send.php';
    final jsonObj = {
      'msg' : string,
      'id' : widget.user.id
    };
    final response = await http.post(
      URL,  // change with your API
      body: jsonObj,
    );
//    print(response.statusCode);
  }
}
