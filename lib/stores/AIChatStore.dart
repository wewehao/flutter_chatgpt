import 'package:aichat/utils/Chatgpt.dart';
import 'package:flutter/cupertino.dart';

class AIChatStore extends ChangeNotifier {
  AIChatStore() {
    syncStorage();
  }

  String chatListKey = 'chatList';
/*
chat
{
  id: Uuid.v4(),
  ai: {
    type: "chat",
    name: "AI Chat",
    "isContinuous": false,
  },
  systemMessage: {
    role: "system",
    content: "Instructions: ",
  },
  messages: [
    {
      role: "user",
      content: "你是谁",
    },
  ],
  createdTime: 0,
  updatedTime: 0,
}
*/
  List chatList = [];

  get sortChatList {
    List sortList = chatList;
    sortList.sort((a, b) {
      return b['updatedTime'].compareTo(a['updatedTime']);
    });
    return sortList;
  }

  get homeHistoryList {
    return sortChatList.take(2).toList();
  }

  Map _createChat(String aiType, String chatId) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Map aiData = ChatGPT.getAiInfoByType(aiType);
    Map chat = {
      "id": chatId,
      "ai": {
        "type": aiData['type'],
        "name": aiData['name'],
        "isContinuous": aiData['isContinuous'],
        "continuesStartIndex": 0,
      },
      "systemMessage": {
        "role": "system",
        "content": aiData['content'],
      },
      "messages": [],
      "createdTime": timestamp,
      "updatedTime": timestamp,
    };

    return chat;
  }

  Future deleteChatById(String chatId) async {
    Map? cacheChat = chatList.firstWhere(
      (v) => v['id'] == chatId,
      orElse: () => null,
    );
    if (cacheChat != null) {
      chatList.removeWhere((v) => v['id'] == chatId);
      await ChatGPT.storage.write(chatListKey, chatList);
      notifyListeners();
    }
  }

  void syncStorage() {
    chatList = ChatGPT.storage.read(chatListKey) ?? [];
    debugPrint('---syncStorage success---');
    notifyListeners();
  }

  void fixChatList() {
    for (int i = 0; i < chatList.length; i++) {
      Map chat = chatList[i];
      for (int k = 0; k < chat['messages'].length; k++) {
        Map v = chat['messages'][k];
        if (v['role'] == 'generating') {
          chatList[i]['messages'][k] = {
            'role': 'error',
            'content': 'Request timeout',
          };
        }
      }
    }
    notifyListeners();
  }

  /// Initialize the page to get data
  Map getChatById(String chatType, String chatId) {
    Map? chat = chatList.firstWhere(
      (v) => v['id'] == chatId,
      orElse: () => null,
    );

    if (chat == null) {
      return _createChat(chatType, chatId);
    }

    return chat;
  }

  Future<Map> pushMessage(Map chat, Map message) async {
    Map? cacheHistory = chatList.firstWhere(
      (v) => v['id'] == chat['id'],
      orElse: () => null,
    );
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    if (cacheHistory != null) {
      chatList.removeWhere((v) => v['id'] == cacheHistory!['id']);
      cacheHistory['messages'].add(message);
      cacheHistory['updatedTime'] = timestamp;
      chatList.add(cacheHistory);
      await ChatGPT.storage.write(chatListKey, chatList);
      notifyListeners();
      return cacheHistory;
    }
    cacheHistory = chat;
    cacheHistory['messages'].add(message);
    cacheHistory['updatedTime'] = timestamp;
    chatList.add(cacheHistory);
    await ChatGPT.storage.write(chatListKey, chatList);
    notifyListeners();
    print('---cacheHistory---$cacheHistory');
    return cacheHistory;
  }

  Future replaceMessage(String chatId, int messageIndex, Map message) async {
    Map? chat = chatList.firstWhere(
      (v) => v['id'] == chatId,
      orElse: () => null,
    );
    if (chat != null) {
      for (var i = 0; i < chatList.length; ++i) {
        Map v = chatList[i];
        if (v['id'] == chatId) {
          int timestamp = DateTime.now().millisecondsSinceEpoch;
          chatList[i]['messages'][messageIndex] = message;
          chatList[i]['updatedTime'] = timestamp;
          break;
        }
      }
      await ChatGPT.storage.write(chatListKey, chatList);
      notifyListeners();
    }
  }

  Future pushStreamMessage(String chatId, int messageIndex, Map message) async {
    if (chatId != '' && message['content'] != '' && message['content'] != null) {
      final index = chatList.indexWhere((v) => v['id'] == chatId);
      Map current = chatList[index]['messages'][messageIndex];

      if (current['role'] != message['role']) {
        chatList[index]['messages'][messageIndex] = message;
      } else {
        chatList[index]['messages'][messageIndex] = {
          "role": message['role'],
          "content": '${current['content']}${message['content']}',
        };
      }

      int timestamp = DateTime.now().millisecondsSinceEpoch;
      chatList[index]['updatedTime'] = timestamp;

      ChatGPT.storage.write(chatListKey, chatList);
      notifyListeners();
    }
  }
}
