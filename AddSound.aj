package ext;

import java.awt.Graphics;

import battleship.model.Place;

public privileged aspect AddSound {

	pointcut shot():within(battleship.model.Board) && call(void *.hit(Place , int));
	
	 after():
		 shot(){ 
		 System.out.println("shot made");
		//new PlaySound().playSound("jamp.wav");
	 }
	 
	 pointcut isSunk():within(battleship.model.Board) && execution(void notifyShipSunk(..));
	 
	 after():
		 isSunk(){
		 System.out.println("sunk af");
	 }
}
