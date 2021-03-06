package ext;

/* @author Jose de La Rosa
 * @author Danner Pacheco
 * 
 * Created for CS3360
 * 
 */



import static battleship.Constants.DEFAULT_BOARD_COLOR;
import static battleship.Constants.DEFAULT_HIT_COLOR;
import static battleship.Constants.DEFAULT_MISS_COLOR;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Random;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Place;
import battleship.model.Ship;

public privileged aspect AddStrategy {

	private boolean reset = false;
	private boolean againstCPU = false;
	JButton playB = new JButton("play");
	Board cpu = new Board(10);
	PlayerPanel cpuPanel = new PlayerPanel(cpu, 10, 10, 30,
			DEFAULT_BOARD_COLOR, DEFAULT_HIT_COLOR, DEFAULT_MISS_COLOR);
	boolean gameover = false;

	Strategies s = new Strategies();
	Coordinates c;
	boolean lastHit = false;
	boolean singleton = false;

	after(BattleshipDialog dialog): 
		this(dialog) && execution(JPanel makeControlPane()){

		JDialog playerBoard = new JDialog(dialog, "Player Board");

		dialog.playButton.setText("practice");

		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playB);

		ActionListener l = new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				againstCPU = true;
				s.createRandList();
				gameover = false;
				int jop = JOptionPane.showConfirmDialog(dialog,
						"wanna do a smart?", "Battleship",
						JOptionPane.YES_NO_OPTION);
				if (jop == JOptionPane.YES_OPTION) {
					isSmart = true;
					dialog.startNewGame();
					playerBoard.repaint();
					if (singleton) {
						reset = true;
						redraw();

						dialog.startNewGame();
						playerBoard.repaint();

					} else
						player(playerBoard);

				} else if (jop == JOptionPane.NO_OPTION) {
					dialog.startNewGame();
					playerBoard.repaint();
					isSmart = false;
					if (singleton) {
						reset = true;
						redraw();

						dialog.startNewGame();
						playerBoard.repaint();

					} else
						player(playerBoard);
				}
			}
		};
		playB.addActionListener(l);
	}

	pointcut addBoard(BattleshipDialog D) : execution(JPanel makeBoardPane()) && this(D);

	pointcut interceptShot() : cflow(execution(void placeClicked(Place))) && !within(PlayerPanel) && call(* *.hit());

	pointcut blockClick() : within(battleship.BoardPanel) && execution( void mouseClicked(..));

	pointcut catchBoard(Board B, BoardPanel bp) : within(battleship.BoardPanel) && execution(BoardPanel.new(..)) && args(B) && this(bp);

	boolean isSmart = false;

	/*This method intercepts the shot made by the player and makes a shot to the player's board. 
	 * If the player chose to play a samrt strategy, the shot made will be chosen by the smart staregy,
	 * else it will be random
	 * 
	 */
	after() : interceptShot(){
		if (againstCPU) {
			if (isSmart) {
				c = s.smartShot(lastHit);
				Place shot = cpu.at(c.getX(), c.getY());
				cpuPanel.placeClicked(shot);

				if (cpu.isGameOver())
					gameover = true;

				if (shot.hasShip())
					lastHit = true;
				else
					lastHit = false;
			} else {
				if (cpu.isGameOver()) {
					gameover = true;
				}
				c = s.randomShot();
				Place shot = cpu.at(c.getX(), c.getY());
				cpuPanel.placeClicked(shot);
			}
		}

	}

	pointcut interceptPlay(BattleshipDialog D) : execution(void playButtonClicked(ActionEvent))  && this(D);

	/*Replaces the code of the original play button to give it the behaviour of a practice button
	 *@param D BattleshipDialog is used to access the methods inside of BattleshipDialog 
	 */
	void around(BattleshipDialog D) : interceptPlay(D){
		int jop = JOptionPane.showConfirmDialog(D,
				"Practice?", "Battleship",
				JOptionPane.YES_NO_OPTION);
		if (jop == JOptionPane.YES_OPTION){
			
			D.startNewGame();

			againstCPU = false;
			cpu.reset();
			cpuPanel.repaint();
		}
		
		else
			return;
		
	}

	/*If the game is over, this disables the input on the board. 
	 * 
	 */
	void around() : blockClick(){
		if (gameover)
			return;
		else
			proceed();

	}

	pointcut checkPractice() : within(battleship.BattleshipDialog) && cflow(execution(void playButtonClicked(ActionEvent))) && call(void startNewGame());

	after(): 
		checkPractice(){
		againstCPU = false;

	}


	/*Redraws the ships when the player decides to play a new game
	 * 
	 */
	public void redraw() {

		Random random = new Random();
		if (reset)
			cpu.reset();
		int size = cpu.size();
		for (Ship ship : cpu.ships()) {
			int i = 0;
			int j = 0;
			boolean dir = false;
			do {
				i = random.nextInt(size) + 1;
				j = random.nextInt(size) + 1;
				dir = random.nextBoolean();
			} while (!cpu.placeShip(ship, i, j, dir));
		}
	}

	/*Creates a new board with the players's ships. 
	 * 
	 */
	private void player(JDialog playerBoard) {

		JPanel newPanel = new JPanel(new BorderLayout());
		Random random = new Random();

		if (reset)
			cpu.reset();
		int size = cpu.size();
		for (Ship ship : cpu.ships()) {
			int i = 0;
			int j = 0;
			boolean dir = false;
			do {
				i = random.nextInt(size) + 1;
				j = random.nextInt(size) + 1;
				dir = random.nextBoolean();
			} while (!cpu.placeShip(ship, i, j, dir));
		}

		playerBoard.setVisible(true);
		Dimension dim = new Dimension(335, 370);
		playerBoard.setSize(dim);
		playerBoard.setLocationRelativeTo(null);

		playerBoard.setLayout(new BorderLayout());
		newPanel.add(cpuPanel, BorderLayout.CENTER);
		playerBoard.add(newPanel, BorderLayout.CENTER);
		reset = false;
		singleton = true;
	}

}