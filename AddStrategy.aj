package ext;

import javax.swing.JButton;
import javax.swing.JPanel;

import battleship.BattleshipDialog;


public privileged aspect AddStrategy {
	JButton playB = new JButton("play");
	after (BattleshipDialog dialog): 
		this(dialog) && execution(JPanel makeControlPane()){
		dialog.playButton.setText("practice");
		JPanel buttons = (JPanel) dialog.playButton.getParent();
		buttons.add(playB);
//		playB.addActionListener();

	}
	
}
