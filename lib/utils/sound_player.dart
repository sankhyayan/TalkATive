import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer = FlutterSoundPlayer();

  Future init()async{
    await _audioPlayer!.openAudioSession();
  }

  Future dispose()async{
    await _audioPlayer!.closeAudioSession();
    _audioPlayer=null;
  }
  Future _play(VoidCallback whenFinished,String url) async {
    await _audioPlayer!.startPlayer(fromURI: url, codec: Codec.aacADTS,whenFinished: whenFinished);
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished,required String url}) async {
    if (_audioPlayer!.isStopped)
      await _play(whenFinished,url);
    else
      await _stop();
  }
   bool get isPlaying=>_audioPlayer!.isPlaying;
}
