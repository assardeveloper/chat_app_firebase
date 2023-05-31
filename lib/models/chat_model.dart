class ChatModel {
  String image;
  String name;
  String lastMessage;
  bool isOnline;
  bool isSelected;
  DateTime lastOnline;

  ChatModel({
    required this.image,
    required this.name,
    required this.lastMessage,
    required this.isOnline,
    required this.isSelected,
    required this.lastOnline,
  });
}

List<ChatModel> chatData = [
  ChatModel(
    image: 'images/woman.jpeg',
    name: 'John Doe',
    lastMessage: 'Hello, how are you?',
    isOnline: true,
    isSelected: false,
    lastOnline: DateTime.now(),
  ),
  ChatModel(
    image: 'images/men.jpg',
    name: 'Jane Smith',
    lastMessage: 'I will be there in 5 minutes.',
    isOnline: false,
    isSelected: false,
    lastOnline: DateTime.now(),
  ),
  ChatModel(
    image: 'images/1.png',
    name: 'Obaid',
    lastMessage: 'I will be there in 5 minutes.',
    isOnline: false,
    isSelected: false,
    lastOnline: DateTime.now(),
  ),
];
