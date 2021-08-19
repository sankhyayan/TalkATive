import 'dart:io';
import 'dart:math';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skype_clone/provider/voiceUploadProvider.dart';
import 'package:skype_clone/resources/storage_methods.dart';

class SoundRecorder {
  final StorageMethods _storageMethods = StorageMethods();
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  bool isRecorderInitialized = false;
  String pathToSaveAudio = "";
  Future init() async {
    final status = await Permission.microphone.request();
    status != PermissionStatus.granted
        ? throw RecordingPermissionException(
            'Microphone permission not granted')
        : print('Microphone permission granted');
    await _audioRecorder!.openAudioSession();
    isRecorderInitialized = true;
  }

  void dispose() async{
    if (!isRecorderInitialized) return;
    await _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    isRecorderInitialized = false;
  }

  Future _record() async {
    if (!isRecorderInitialized) return;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(10000);
    final pathToSave = "$path/audio_$random.aac";
    pathToSaveAudio = pathToSave;
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async {
    if (!isRecorderInitialized) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    _audioRecorder!.isStopped ? await _record() : await _stop();
  }

  Future uploadAudioFile({
    required String senderId,
    required String receiverId,
    required VoiceUploadProvider voiceUploadProvider,
  }) async {
    if (_audioRecorder!.isStopped && await File(pathToSaveAudio).exists()) {
      _storageMethods.uploadVoice(
        voice: File(pathToSaveAudio),
        voiceUploadProvider: voiceUploadProvider,
        senderId: senderId,
        receiverId: receiverId,
      );
    }
  }

  bool get isRecording => _audioRecorder!.isRecording;
}
