package ext;

import java.awt.Graphics;

import battleship.BoardPanel;

public aspect AddSound {

	pointcut checkHit():
	 execution(boolean *.isHit());

	 before():
		 checkHit(){
		 	System.out.println("a shot was made");
	 	}
}
