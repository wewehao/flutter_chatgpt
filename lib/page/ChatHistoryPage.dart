import 'package:aichat/page/ChatPage.dart';
import 'package:aichat/page/SettingPage.dart';
import 'package:aichat/utils/Config.dart';
import 'package:aichat/utils/Time.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:provider/provider.dart';

class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({Key? key}) : super(key: key);

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.white,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 60,
                child: Row(
                  children: const [
                    SizedBox(width: 24),
                    Image(
                      width: 18,
                      image: AssetImage('images/back_icon.png'),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "History",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: const [
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _renderChatListWidget(
                store.sortChatList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderChatListWidget(List chatList) {
    // List<Widget> list = [];
    // for (var i = 0; i < chatList.length; i++) {
    //   list.add(
    //     _genChatItemWidget(chatList[i]),
    //   );
    // }
    // return SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       ...list,
    //       const SizedBox(height: 20),
    //     ],
    //   ),
    // );

    return ListView.builder(
      reverse: false,
      itemCount: chatList.length,
      itemBuilder: (BuildContext context, int index) {
        return _genChatItemWidget(chatList[index]);
      },
    );
  }

  Widget _genChatItemWidget(Map chat) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        final store = Provider.of<AIChatStore>(context, listen: false);
        store.fixChatList();
        Utils.jumpPage(
          context,
          ChatPage(
            chatId: chat['id'],
            autofocus: false,
            chatType: chat['ai']['type'],
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (chat['updatedTime'] != null)
                      Text(
                        TimeUtils().formatTime(
                          chat['updatedTime'],
                          format: 'dd/MM/yyyy HH:mm',
                        ),
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      chat['messages'][0]['content'],
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 22,
                ),
                color: const Color.fromARGB(255, 145, 145, 145),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, chat['id']);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(
            height: 2,
            color: Color.fromRGBO(166, 166, 166, 1.0),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String chatId,
  ) async {
    final store = Provider.of<AIChatStore>(context, listen: false);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm deletion?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await store.deleteChatById(chatId);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
