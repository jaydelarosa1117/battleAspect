package ext;

import java.awt.Graphics;

import battleship.BoardPanel;
import battleship.model.Board;

public aspect AddCheatKey {

	int around():
		within(battleship.BattleshipDialog) && call(int *.nextInt(..)){
		int tx = proceed();
		System.out.println(tx + 1);
		return tx;
	}

	boolean around():
		within(battleship.BattleshipDialog) && call(boolean *.nextBoolean(..)){
		boolean direction = proceed();
		System.out.println("\tdir of ship" + direction);
		return direction;
	}

	after():
		within(battleship.BoardPanel) && execution(BoardPanel.new(Board)){

	}

	pointcut isSee() : within(battleship.BoardPanel) && cflow(call(void drawPlaces(Graphics))) && call(boolean *isHit(..));

	boolean around():
		isSee(){
		return true;
	}

}
