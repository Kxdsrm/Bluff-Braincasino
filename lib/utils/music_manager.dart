import 'package:audioplayers/audioplayers.dart';
import 'package:bluff_brain/storage/storage_keys.dart';

import '../storage/storage_utils.dart';


class MusicManager{

  static AudioPlayer musicPlayer = AudioPlayer();
  static AudioPlayer bgMusic = AudioPlayer();

  static String mBtnClick= "music/button_click.mp3";
  static String mHeavenlyBonus= "music/heavenly_bonus.wav";
  static String mQuizBgMusic= "music/quiz_bg_music.mp3";
  static String mQuizCountdown= "music/quiz_countdown.mp3";
  static String mSpellOfReward= "music/spell_of_reward.wav";
  static String mWinGame107= "music/win_game_level_107.wav";


  MusicManager(){

    if(musicPlayer == null){
      musicPlayer = AudioPlayer();
    }

    if(bgMusic == null){
      bgMusic = AudioPlayer();
    }
  }

  Future<void> playMusic(String sources) async {
    try {
      bool isMusic = await StorageUtils.getBool(kMusic);
      print("isMusic : $isMusic");
      if (isMusic) {
        musicPlayer.play(AssetSource(sources));
      } else {
        musicPlayer.stop();
      }
    }catch(e){}
  }

  Future<void> playBackGroundMusic(String sources) async {
    bool isMusic = await StorageUtils.getBool(kQuizMusic);
    print("isMusic : $isMusic");
    if(isMusic){
      bgMusic.setVolume(0.2);
      bgMusic.play(AssetSource(sources));
    }else{
      stopBackgroundMusic();
    }
  }

  stopMusic(){
    try {
      if (musicPlayer != null) {
        musicPlayer.stop();
      }
    }catch(e){}
  }

  stopBackgroundMusic(){
    try {
      if (bgMusic != null) {
        bgMusic.stop();
      }
    }catch(e){}
  }

}