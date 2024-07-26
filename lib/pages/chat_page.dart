import 'package:chatly/components/chat_bubble.dart';
import 'package:chatly/components/my_textfield.dart';
import 'package:chatly/services/auth/auth_services.dart';
import 'package:chatly/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  
  final String receiverEmail;
  final String receiverID;

   const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    //! text controller --
    final TextEditingController _messageController = TextEditingController();

    //! chat & auth services --
    final ChatServices _chatServices = ChatServices();
    final AuthServices _authServices = AuthServices();

    //! for textfield focus --
    FocusNode myFocusNode = FocusNode();

    @override
  void initState() {
    super.initState();

    //* add listner to focus node
    myFocusNode.addListener((){
      if (myFocusNode.hasFocus) {
        //* cause a delay so that the keyboard has time to show up
        //* then the amount of remaining space will be calculated
        //* then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //! scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.fastOutSlowIn,
      );
  }

    //! send message
    void sendMessage() async {
      //* if there is somthing inside the textfield
      if (_messageController.text.isNotEmpty) {
        //* send the message
        await _chatServices.sendMessage(widget.receiverID, _messageController.text);

        //* clear text controller
        _messageController.clear();
      }

      scrollDown();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        ),
      body: Column(
        children: [
          //! display all the messages --
          Expanded(
            child: _buildMessageList(),
          ),

          //! user input --
          _buildUserInput(),
        ],
      ),
    );
  }

  //! build message list
Widget _buildMessageList(){
  String senderID = _authServices.getCurrentUser()!.uid;
  return StreamBuilder(
    stream: _chatServices.getMessages(widget.receiverID, senderID), 
    builder: (context, snapshot){
      //* errors
      if (snapshot.hasError) {
        return const Text("Error");
      }

      //* loading
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
              child: CircularProgressIndicator(),
            );
      }

      //* return list view
      return ListView(
        controller: _scrollController,
        children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
      );
    }
    );
  }

  //! build message item --
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //* is current user
    bool isCurrentUser = data['senderID'] == _authServices.getCurrentUser()!.uid;


    //* align message to the right if otherwise left
    var alignment = isCurrentUser? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"], 
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data['senderID'],
            ),
        ],
      )
      );
  }

  //! build message input --
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom :30.0),
      child: Row(
        children: [
          //* textfield should take up most of the space
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: "Type a message", 
              obscureText: false, 
              focusNode: myFocusNode,
              ),
            ),
      
          //* send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                ),
              ),
          )  
        ],
      ),
    );
  }
}

