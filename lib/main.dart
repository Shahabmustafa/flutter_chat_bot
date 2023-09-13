import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'message.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}


class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController controller = TextEditingController();
  List<Map<String,dynamic>> messages = [];
  @override
  void initState() {
    // TODO: implement initState
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Bot"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: MessagePage(messages: messages),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Enter a Message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          sendMessage(controller.text);
                          controller.clear();
                        },
                        icon: Icon(Icons.send)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  sendMessage(String text)async{
    if(text.isEmpty){

    }else{
      setState(() {
        addMessage(
          Message(text: DialogText(text: [text])),true);
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if(response.message == null)return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message,[bool isUserMessage = false]){
    messages.add({
      "message" : message,
      "isUserMessage" : isUserMessage,
    });
  }
}


