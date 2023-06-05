import 'package:chat_app_course/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

class VoiceRecoder extends StatefulWidget {
  final String groupId;
  final String currentUserId;
  final String userName;
  const VoiceRecoder({super.key,required this.currentUserId,required this.groupId,required this.userName});

  @override
  State<VoiceRecoder> createState() => _VoiceRecoderState();
}

class _VoiceRecoderState extends State<VoiceRecoder> {
  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of(context);
    return Scaffold(
     
      appBar: AppBar(
        title: const Text("Voice Recorder"),
      ),
      body: SocialMediaRecorder(
        sendRequestFunction: (soundFile) async {
          String voiceURL = await chatProvider.uploadImage(soundFile);
          chatProvider.sendMessage(
            groupId:widget.groupId,
            id: widget.currentUserId,
            message: voiceURL,
            name: widget.userName,
            type: "voice"
          );
      
        },
        encode: AudioEncoderType.AAC,
      ),
    );
  }
}
