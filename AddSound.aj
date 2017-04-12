package ext;

import java.io.IOException;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import battleship.model.Place;

public privileged aspect AddSound {
	
	
	
	
	
	/** Directory where audio files are stored. */
    private static final String SOUND_DIR = "";

    /** Play the given audio file. Inefficient because a file will be 
     * (re)loaded each time it is played. */
    public static void playAudio(String filename) {
      try {
          AudioInputStream audioIn = AudioSystem.getAudioInputStream(
	    AddSound.class.getResource(SOUND_DIR + filename));
          Clip clip = AudioSystem.getClip();
          clip.open(audioIn);
          clip.start();
      } catch (UnsupportedAudioFileException 
            | IOException | LineUnavailableException e) {
          e.printStackTrace();
      }
    }
	
	
	
	

	pointcut shot():within(battleship.model.Board) && call(void notifyHit(Place , int));
	
	 after():
		 shot(){ 
		 System.out.println("shot made");
		//playAudio("jamp.wav");
	 }
	 
	 pointcut isSunk():within(battleship.model.Board) && execution(void notifyShipSunk(..));
	 
	 after():
		 isSunk(){
		 System.out.println("sunk af");
	 }
}
