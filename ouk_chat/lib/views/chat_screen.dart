import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/chat_controller.dart';
import '../models/room_model.dart';
import '../models/chat_message_model.dart';

class ChatScreen extends GetView<ChatController> {
  final Room room;
  final ScrollController _scrollController = ScrollController();

  ChatScreen({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 ${room.id}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.messages.length + (controller.isLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (controller.isLoading.value && index == controller.messages.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "답변을 기다리는 중...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final message = controller.messages[index];
                  final isUser = message.type == MessageType.human;

                  return Container(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (!isUser && message.sources != null && message.sources!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: message.sources!.map((source) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () => _launchURL(source.url),
                                      child: Column(
                                        children: [
                                          Chip(
                                            label: Text(
                                              source.title,
                                              style: const TextStyle(color: Colors.blue),
                                            ),
                                            backgroundColor: Colors.blue[50],
                                          ),
                                        ],
                                      )
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController messageController = TextEditingController();

    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: const EdgeInsets.only(bottom: 20),
        color: Colors.grey[200],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                enabled: !controller.isLoading.value,
                decoration: InputDecoration(
                  hintText: controller.isLoading.value
                      ? '답변을 기다리는 중...'
                      : '메시지를 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSubmitted: (message) {
                  if (!controller.isLoading.value && message.isNotEmpty) {
                    controller.sendMessage(message);
                    messageController.clear();
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: controller.isLoading.value ? Colors.grey : Colors.blue,
              ),
              onPressed: () {
                final message = messageController.text.trim();
                if (!controller.isLoading.value && message.isNotEmpty) {
                  controller.sendMessage(message);
                  messageController.clear();
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('오류', 'URL을 열 수 없습니다.');
    }
  }
}
