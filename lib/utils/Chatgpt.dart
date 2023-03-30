import 'package:dart_openai/openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class ChatGPT {
  static ChatGPT _instance = ChatGPT._();

  factory ChatGPT() => _getInstance();

  static ChatGPT get instance => _getInstance();

  ChatGPT._() {}

  static ChatGPT _getInstance() {
    _instance ??= ChatGPT._();
    return _instance;
  }

  static GetStorage storage = GetStorage();

  static String chatGptToken = ''; // token
  static String defaultModel = 'gpt-3.5-turbo';
  static List defaultRoles = [
    'system',
    'user',
    'assistant'
  ]; // generating | error

  static List chatModelList = [
    {
      "type": "chat",
      "name": "AI Chat",
      "desc": "Natural language chat, continuous conversation mode",
      "isContinuous": true,
      "content": "\nInstructions:"
          "\nYou are ChatGPT. The answer to each question should be as concise as possible. If you're making a list, don't have too many entries."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "Can you write a poem?",
        "Can you write a joke?",
        "Help me plan a trip",
      ],
    },
    {
      "type": "translationLanguage",
      "name": "Translate language",
      "desc": "Translate A language to B language",
      "isContinuous": false,
      "content": '\nnInstructions:\n'
          'I want you to act as a translator. You will recognize the language, translate it into the specified language and answer me. Please do not use an interpreter accent when translating, but to translate naturally, smoothly and authentically, using beautiful and elegant expressions. I will give you the format of "Translate A to B". If the format I gave is wrong, please tell me that the format of "Translate A to B" should be used. Please only answer the translation part, do not write the explanation.'
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "Translate love to chinese",
        "Translate cute to chinese",
        "Translate How are you to chinese",
      ],
    },
    {
      "type": "englishTranslatorAndImprover",
      "name": "English Translator and Improver",
      "desc": "English translation, spell checking and rhetorical improvement",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as an English translator, spelling corrector and improver. I will speak to you in any language and you will detect the language, translate it and answer in the corrected and improved version of my text, in English. I want you to replace my simplified A0-level words and sentences with more beautiful and elegant, upper level English words and sentences. Keep the meaning same, but make them more literary. I want you to only reply the correction, the improvements and nothing else, do not write explanations."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "I want to keep a cat",
        "Look! It's a husky!",
      ],
    },
    {
      "type": "frontEndHelper",
      "name": "Front-end Helper",
      "desc": "Act as a front-end helper",
      "isContinuous": false,
      "content": '\nnInstructions:\n'
          "I want you to be an expert in front-end development. I'm going to provide some specific information about front-end code issues with Js, Node, etc., and your job is to come up with a strategy to solve the problem for me. This may include suggesting code, strategies for logical thinking about code."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "JavaScript array deduplication",
      ],
    },
    {
      "type": "linuxTerminal",
      "name": "Act as a Linux Terminal",
      "desc":
          "AI linux terminal. Enter the command and the AI will reply with what the terminal should display",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a linux terminal. I will type commands and you will reply with what the terminal should show. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. do not type commands unless I instruct you to do so. When I need to tell you something in English, I will do so by putting text inside curly brackets {like this}."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "pwd",
        "ls",
      ],
    },
    {
      "type": "positionInterviewer",
      "name": "Act as position Interviewer",
      "desc":
          "AI interviewer. As a candidate, AI will ask you interview questions for the position",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as an interviewer. I will be the candidate and you will ask me the interview questions for the position position. I want you to only reply as the interviewer. Do not write all the conservation at once. I want you to only do the interview with me. Ask me the questions and wait for my answers. Do not write explanations. Ask me the questions one by one like an interviewer does and wait for my answers."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "Hello, I'm a front-end development engineer",
        "Hello, I'm a car maintenance man",
        "Hello, I'm a financial officer",
      ],
    },
    {
      "type": "javaScriptConsole",
      "name": "Act as a JavaScript Console",
      "desc":
          "As javascript console. Type the command and the AI will reply with what the javascript console should show",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a javascript console. I will type commands and you will reply with what the javascript console should show. I want you to only reply with the terminal output inside one unique code block, and nothing else. do not write explanations. do not type commands unless I instruct you to do so. when I need to tell you something in english, I will do so by putting text inside curly brackets {like this}."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        'console.log("Hello World");',
        'window.alert("Hello");',
      ],
    },
    {
      "type": "excelSheet",
      "name": "Act as an Excel Sheet",
      "desc":
          "Acts as a text-based excel. You'll only respond to my text-based 10-row Excel sheet with row numbers and cell letters as columns (A through L)",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a text based excel. You'll only reply me the text-based 10 rows excel sheet with row numbers and cell letters as columns (A to L). First column header should be empty to reference row number. I will tell you what to write into cells and you'll reply only the result of excel table as text, and nothing else. Do not write explanations. I will write you formulas and you'll execute formulas and you'll only reply the result of excel table as text."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "Reply me the empty sheet",
      ],
    },
    {
      "type": "spokenEnglishTeacher",
      "name": "Act as a Spoken English Teacher and Improver",
      "desc":
          "Talk to AI in English, AI will reply you in English to practice your English speaking",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a spoken English teacher and improver. I will speak to you in English and you will reply to me in English to practice my spoken English. I want you to keep your reply neat, limiting the reply to 100 words. I want you to strictly correct my grammar mistakes, typos, and factual errors. I want you to ask me a question in your reply. Remember, I want you to strictly correct my grammar mistakes, typos, and factual errors."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "Now let's start practicing",
      ],
    },
    {
      "type": "travelGuide",
      "name": "Act as a Travel Guide",
      "desc":
          "Write down your location and AI will recommend attractions near you",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a travel guide. I will write you my location and you will suggest a place to visit near my location. In some cases, I will also give you the type of places I will visit. You will also suggest me places of similar type that are close to my first location."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "I am in Istanbul/Beyoğlu and I want to visit only museums.",
      ],
    },
    {
      "type": "storyteller",
      "name": "Act as a Storyteller",
      "desc":
          "AI will come up with interesting stories that are engaging, imaginative and captivating to the audience",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a storyteller. You will come up with entertaining stories that are engaging, imaginative and captivating for the audience. It can be fairy tales, educational stories or any other type of stories which has the potential to capture people's attention and imagination. Depending on the target audience, you may choose specific themes or topics for your storytelling session e.g., if it’s children then you can talk about animals; If it’s adults then history-based tales might engage them better etc. "
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        "I need an interesting story on perseverance.",
      ],
    },
    {
      "type": "novelist",
      "name": "Act as a Novelist",
      "desc":
          "AI plays a novelist. You'll come up with creative and engaging stories",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as a novelist. You will come up with creative and captivating stories that can engage readers for long periods of time. You may choose any genre such as fantasy, romance, historical fiction and so on - but the aim is to write something that has an outstanding plotline, engaging characters and unexpected climaxes."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        'I need to write a science-fiction novel set in the future.',
      ],
    },
    {
      "type": "legalAdvisor",
      "name": "Act as a Legal Advisor",
      "desc":
          "AI as your legal advisor. You need to describe a legal situation and the AI will provide advice on how to handle it",
      "isContinuous": false,
      "content": "\nInstructions:"
          "\nI want you to act as my legal advisor. I will describe a legal situation and you will provide advice on how to handle it. You should only reply with your advice, and nothing else. Do not write explanations."
          " If possible, please format it in a friendly markdown format."
          '\n',
      "tips": [
        'I’m making surrealistic portrait paintings',
      ],
    },
  ];

  static Future<void> setOpenAIKey(String key) async {
    await storage.write('OpenAIKey', key);
    await initChatGPT();
  }

  static String getCacheOpenAIKey() {
    String? key = storage.read('OpenAIKey');
    if (key != null && key != '' && key != chatGptToken) {
      return key;
    }
    return '';
  }

  static Set chatModelTypeList =
      chatModelList.map((map) => map['type']).toSet();

  /// 实现通过type获取信息
  static getAiInfoByType(String chatType) {
    return chatModelList.firstWhere(
      (item) => item['type'] == chatType,
      orElse: () => null,
    );
  }

  static Future<void> initChatGPT() async {
    String cacheKey = getCacheOpenAIKey();
    OpenAI.apiKey = cacheKey != '' ? cacheKey : chatGptToken;
  }

  static getRoleFromString(String role) {
    if (role == "system") return OpenAIChatMessageRole.system;
    if (role == "user") return OpenAIChatMessageRole.user;
    if (role == "assistant") return OpenAIChatMessageRole.assistant;
    return "unknown";
  }

  static convertListToModel(List messages) {
    List<OpenAIChatCompletionChoiceMessageModel> modelMessages = [];
    for (var element in messages) {
      modelMessages.add(OpenAIChatCompletionChoiceMessageModel(
        role: getRoleFromString(element["role"]),
        content: element["content"],
      ));
    }
    return modelMessages;
  }

  static List filterMessageParams(List messages) {
    List newMessages = [];
    for (var v in messages) {
      if (defaultRoles.contains(v['role'])) {
        newMessages.add({
          "role": v["role"],
          "content": v["content"],
        });
      }
    }
    return newMessages;
  }

  static Future<bool> checkRelation(
    List beforeMessages,
    Map message, {
    String model = '',
  }) async {
    beforeMessages = filterMessageParams(beforeMessages);
    String text = "\nInstructions:"
        "\nCheck whether the problem is related to the given conversation. If yes, return true. If no, return false. Please return only true or false. The answer length is 5."
        "\nquestion：$message}"
        "\nconversation：$beforeMessages"
        "\n";
    OpenAIChatCompletionModel chatCompletion = await sendMessage(
      [
        {
          "role": 'user',
          "content": text,
        }
      ],
      model: model,
    );
    debugPrint('---text $text---');
    String content = chatCompletion.choices.first.message.content ?? '';
    bool hasRelation = content.toLowerCase().contains('true');
    debugPrint('---检查问题前后关联度 $hasRelation---');
    return hasRelation;
  }

  static Future<OpenAIChatCompletionModel> sendMessage(
    List messages, {
    String model = '',
  }) async {
    messages = filterMessageParams(messages);
    List<OpenAIChatCompletionChoiceMessageModel> modelMessages =
        convertListToModel(messages);
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: model != '' ? model : defaultModel,
      messages: modelMessages,
    );
    return chatCompletion;
  }

  static Future sendMessageOnStream(
    List messages, {
    String model = '',
    Function? onProgress,
  }) async {
    messages = filterMessageParams(messages);
    List<OpenAIChatCompletionChoiceMessageModel> modelMessages =
        convertListToModel(messages);

    Stream<OpenAIStreamChatCompletionModel> chatStream =
        OpenAI.instance.chat.createStream(
      model: defaultModel,
      messages: modelMessages,
    );
    print(chatStream);

    chatStream.listen((chatStreamEvent) {
      print('---chatStreamEvent---');
      print('$chatStreamEvent');
      print('---chatStreamEvent end---');
      if (onProgress != null) {
        onProgress(chatStreamEvent);
      }
    });
  }

  static Future<OpenAIImageModel> genImage(String imageDesc) async {
    debugPrint('---genImage starting: $imageDesc---');
    OpenAIImageModel image = await OpenAI.instance.image.create(
      prompt: imageDesc,
      n: 1,
      size: OpenAIImageSize.size1024,
      responseFormat: OpenAIImageResponseFormat.url,
    );
    debugPrint('---genImage success: $image---');
    return image;
  }
}
