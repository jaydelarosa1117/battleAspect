package ext;


/* @author Jose de La Rosa
 * @author Danner Pacheco
 * 
 * Created for CS3360
 * 
 */

import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;

import javax.swing.AbstractAction;
import javax.swing.ActionMap;
import javax.swing.InputMap;
import javax.swing.JComponent;
import javax.swing.KeyStroke;

import battleship.BoardPanel;
import battleship.model.Place;

public privileged aspect AddCheatKey {
	boolean doCheat = false;
	Graphics g;
	BoardPanel b;

	pointcut cheatPrt(Graphics g, BoardPanel b) : within(battleship.BoardPanel) && execution(void paint(Graphics)) && args(g) && this(b) ;

	
	after(Graphics g, BoardPanel b):
		cheatPrt(g,b){
		if (doCheat) {
			showShips(g, b);
		}
	}

	/*This method draws the cheatkey on top of the board. 
	 * It is a modified version of the method found inside BoardPanel
	 * @param b BoardPanel stores the ships that are usually hidden;
	 * 
	 */
	public static void showShips(Graphics g, BoardPanel b) {
		for (Place p : b.board.places()) {
			if (p.hasShip()) {
				int x = b.leftMargin + (p.getX() - 1) * b.placeSize;
				int y = b.topMargin + (p.getY() - 1) * b.placeSize;
				g.setColor(Color.ORANGE);
				g.fillRect(x + 1, y + 1, b.placeSize - 1, b.placeSize - 1);
			}
			if (p.isHit()) {
				int x = b.leftMargin + (p.getX() - 1) * b.placeSize;
				int y = b.topMargin + (p.getY() - 1) * b.placeSize;
				g.setColor(p.isEmpty() ? b.missColor : b.hitColor);
				g.fillRect(x + 1, y + 1, b.placeSize - 1, b.placeSize - 1);
				if (p.hasShip() && p.ship().isSunk()) {
					g.setColor(Color.BLACK);
					g.drawLine(x + 1, y + 1, x + b.placeSize - 1, y
							+ b.placeSize - 1);
					g.drawLine(x + 1, y + b.placeSize - 1, x + b.placeSize - 1,
							y + 1);
				}
			}

		}
	}

	pointcut addcode(BoardPanel p) : execution(BoardPanel.new(..)) && this(p);

	/*Executes the code that allows the f5 key to be used
	 * @param p BoardPanel is used to insert the code into the boardPanel
	 * 
	 */
	after(BoardPanel p): addcode(p){
		ActionMap actionMap = p.getActionMap();
		int condition = JComponent.WHEN_IN_FOCUSED_WINDOW;
		InputMap inputMap = p.getInputMap(condition);
		String cheat = "Cheat";

		inputMap.put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0), cheat);

		actionMap.put(cheat, new KeyAction(p, "Cheat"));

	}

	@SuppressWarnings("serial")
	class KeyAction extends AbstractAction {
		private final BoardPanel boardPanel;

		public KeyAction(BoardPanel boardPanel, String command) {
			this.boardPanel = boardPanel;
			putValue(ACTION_COMMAND_KEY, command);
		}

		/** Called when a cheat is requested. */
		public void actionPerformed(ActionEvent event) {
			doCheat = !doCheat;
			boardPanel.repaint();
		}
	}

}