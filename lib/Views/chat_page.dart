import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_chat_app/pages/gallary_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assignment_assist/Model/chat_model.dart';
import 'package:assignment_assist/Services/api_path.dart';
import 'package:assignment_assist/Services/tokenString.dart';
import 'package:assignment_assist/Utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  // final SharedPreferences prefs;
    String? bookingId;
  // final String? title;
  // final User? user;
  final providerName,providerId,providerImage;
  ChatPage({this.providerId,this.providerImage,this.providerName,this.bookingId});
  @override
  ChatPageState createState() {
    return new ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  StreamController<ChatModel>? _postsController;
  //
  // final db = FirebaseFirestore.instance;
  // CollectionReference? chatReference;
   final TextEditingController textController =  TextEditingController();
  final TextEditingController msgController =  TextEditingController();
  bool _isWritting = false;

  @override
  void initState() {
    _postsController = new StreamController();
    loadMessage();
    super.initState();


    // chatReference =
    //     db.collection("chats").doc(userID).collection('messages');
  }

  File? imageFiles;
Future getMessage()async{
  var headers = {
    'Cookie': 'ci_session=132b223a903b145b8f1056a17a0c9ef325151d5f'
  };
  var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getChats));
  request.fields.addAll({
    'booking_id': '${widget.bookingId}'
  });
  print("this is chat request ${request.fields.toString()}");
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    var finalResult = await response.stream.bytesToString();
     final jsonResponse = ChatModel.fromJson(json.decode(finalResult));
     print("yes it is working here ${jsonResponse}");
    // setState(() {
    //   ChatModel = jsonResponse;
    // });
    //return json.decode(finalResult);
    return ChatModel.fromJson(json.decode(finalResult));
  }
  else {
    print(response.reasonPhrase);
  }

}

loadMessage()async{
getMessage().then(( res)async{
  _postsController!.add(res);
  return res;
});
}
String? userID;

  sendChatMessage(String type)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
   userID =   prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=cb5fe5415a2e7a3e28f499c842c30404bfbc8a99'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.sendMessages));
    request.fields.addAll({
      'sender_id': '${userID}',
      'sender_type': 'user',
      'message': msgController.text.toString(),
      'message_type': '${type}',
      'booking_id': '${widget.bookingId}',
    });
   imageFiles == null ? null : request.files.add(await http.MultipartFile.fromPath('chat', imageFiles!.path.toString()));
   print("ok checking here--  ${request.fields} ");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("final json here $jsonResponse");
      getMessage().then(( res)async{
        _postsController!.add(res);
        return res;
      });
      setState(() {
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }


  generateMessages(AsyncSnapshot<ChatModel> snapshot){
    return snapshot.data!.chattings!
        .map<Widget>((doc){
          print("check docs here ${doc}");
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
                children:[
                  Expanded(
                    child:  Column(
                      crossAxisAlignment: doc.senderType == "user" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: <Widget>[
                        // doc['sender_id'] != "1"?
                        // generateReceiverLayout(doc)
                        // Text("receiver end ")
                        //     :
                        // widget.providerId == doc['id']
                        //     ?
                    doc.message == ""  || doc.message == null ? const SizedBox.shrink() : doc.messageType == "image" ? InkWell(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => OpenImagePage(image: "${doc.message}",)));
                      },
                      child: Container(
                        height: 90,
                        width: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network("${doc.message}",fit: BoxFit.fill,)),
                      ),
                    ) :  Container(
                          padding:EdgeInsets.all(6),
                          decoration:BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Text("${doc.message}",
                              // widget.user!.name.toString(),
                               //documentSnapshot.data['sender_name'],
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ]
              //doc.data['sender_id']
              //     "1" != "1"
              // ? generateReceiverLayout(doc)
              // : generateSenderLayout(doc),
            ),
          );
    } )
        .toList();
  }
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  //RegExp regExp = RegExp(pattern);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Admin',
          // '${widget.providerName}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),

        )
        // Padding(
        //   padding: const EdgeInsets.all(12),
        //   child: RawMaterialButton(
        //     shape: CircleBorder(),
        //     padding: const EdgeInsets.all(0),
        //     fillColor: Colors.white,
        //     splashColor: Colors.grey[400],
        //     child: Icon(
        //       Icons.arrow_back_ios,
        //       size: 20,
        //       color: whiteColor,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        // )

      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child:  Column(
          children: <Widget>[
            StreamBuilder<ChatModel>(
              stream: _postsController!.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<ChatModel> snapshot) {
                if (!snapshot.hasData) return  Text("No Chat");
                return Expanded(
                  child:
                  ListView(
                    reverse: false,
                    children: generateMessages(snapshot),
                  ),
                );
              }, 
            ),
             // TextFormField(
             //   controller: msgController,
             // ),
             const Divider(height: 1.0),
             Container(
              decoration:  BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
             Builder(builder: (BuildContext context) {
              return  Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }

  IconButton getDefaultSendButton() {
    return  IconButton(
      icon:  Icon(Icons.send,color: primaryColor,),
      onPressed: (){
        // if(textController.text.contains(".com")){
        //   Fluttertoast.showToast(msg: "Email are not allowed");
        // }
        // else if(textController.text.contains(RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$'))){
        //   Fluttertoast.showToast(msg: "Mobile numbers are not allowed");
        // }
        // else{
          setState(() {
            sendChatMessage("text");
            getMessage().then(( res)async{
              _postsController!.add(res);
              return res;
            });
            Future.delayed(Duration(seconds: 2),(){
              msgController.clear();
            });

          });
        // }
      }
    );
  }

  Widget _buildTextComposer() {
    return  IconTheme(
        data:  IconThemeData(
          color: _isWritting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child:  Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child:  Row(
            children: <Widget>[
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child:  IconButton(
                    icon:  Icon(
                      Icons.photo_camera,
                      color: primaryColor,
                    ),
                    onPressed: () async {
                      // var image = await ImagePicker.
                      // pickImage(
                      //     source: ImageSource.gallery);
                      // int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      // StorageReference storageReference = FirebaseStorage
                      //     .instance
                      //     .ref()
                      //     .child('chats/img_' + timestamp.toString() + '.jpg');
                      // StorageUploadTask uploadTask =
                      // storageReference.putFile(image);
                      // await uploadTask.onComplete;
                      // String fileUrl = await storageReference.getDownloadURL();
                      PickedFile? image = await ImagePicker.platform
                          .pickImage(source: ImageSource.gallery);
                      imageFiles = File(image!.path);
                      print("image files here ${imageFiles!.path.toString()}");
                      if(imageFiles != null){
                        setState(() {
                          sendChatMessage("image");
                          getMessage().then(( res)async{
                            _postsController!.add(res);
                            return res;
                          });
                          // textController.clear();
                        });
                      }
                    }),
              ),
               Flexible(
                child:  TextFormField(
                  controller: msgController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.length > 0;
                    });
                  },
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp(pattern))
                    // ],
                  // onSubmitted: _sendMsg,
                  keyboardType: TextInputType.text,
                  decoration:
                   const InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
               Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  // Future<Null> _sendText(String text) async {
  //   _textController.clear();
  //   chatReference!.add({
  //     'text': text,
  //     'receiver_id': "1",
  //     "sender_id" : "1",
  //     //widget.prefs.getString('uid'),
  //     'receiver_name': "Karan",
  //     //widget.prefs.getString('name'),
  //     'profile_photo' : "",
  //   //widget.prefs.getString('profile_photo'),
  //     'image_url': '',
  //     'time': FieldValue.serverTimestamp(),
  //   }).then((documentReference) {
  //     setState(() {
  //       _isWritting = false;
  //     });
  //   }).catchError((e) {});
  // }

  //  _sendMsg(String text) async {
  //   _textController.clear();
  //   chatReference!.add({
  //     'text': text,
  //     'received' : true,
  //     'id': "${widget.providerId}",
  //     "sender_id" : "${userID}",
  //     //widget.prefs.getString('uid'),
  //     'name': "${widget.providerName}",
  //     //widget.prefs.getString('name'),
  //     'profile_photo' : "${widget.providerImage}",
  //   //widget.prefs.getString('profile_photo'),
  //     'image_url': '',
  //     'time': '',
  //   }).then((documentReference) {
  //     setState(() {
  //       _isWritting = false;
  //     });
  //   }).catchError((e) {});
  // }
  // void _sendImage({ String? messageText, String? imageUrl}) {
  //   chatReference!.add({
  //     'text': messageText,
  //
  //     // 'sender_id': widget.prefs.getString('uid'),
  //     // 'sender_name': widget.prefs.getString('name'),
  //     // 'profile_photo': widget.prefs.getString('profile_photo'),
  //     'image_url': imageUrl,
  //     'time': FieldValue.serverTimestamp(),
  //   });
  // }
}