package ext;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;

public class Strategies {
	private boolean[][] shotsDone;

	private Stack<Coordinates> possibleHits;
	private Queue<Coordinates> randCoordinates;

	public Strategies() {
		shotsDone = new boolean[10][10];
		possibleHits = new Stack<>();
		randCoordinates = new LinkedList<Coordinates>();
		createRandList();
	}

	public void createRandList() {
		shotsDone = new boolean[10][10];
		possibleHits = new Stack<>();
		randCoordinates = new LinkedList<Coordinates>();
		ArrayList<Coordinates> randList = new ArrayList<Coordinates>();
		for (int i = 1; i <= 10; i++) {
			for (int j = 1; j <= 10; j++) {
				randList.add(new Coordinates(i, j));
			}
		}
		Collections.shuffle(randList);
		for (int i = 0; i < randList.size(); i++) {
			randCoordinates.add(randList.get(i));
		}
		randList = null;
	}

	public Coordinates randomShot() {
		Coordinates temp;
		while (true) {
			temp = randCoordinates.remove();

			if (!shotsDone[temp.getY() - 1][temp.getX() - 1]) {
				shotsDone[temp.getY() - 1][temp.getX() - 1] = true;
				return temp;
			}
		}
	}

	public void addToStack(Coordinates c) {
		int x = c.getX(), y = c.getY();

		if (x == 1 && y == 1) {
			possibleHits.push(new Coordinates(2, 1));
			possibleHits.push(new Coordinates(1, 2));
			return;
		} else if (x == 1 && y == 10) {
			possibleHits.push(new Coordinates(2, 10));
			possibleHits.push(new Coordinates(1, 9));
			return;
		} else if (x == 10 && y == 1) {
			possibleHits.push(new Coordinates(9, 1));
			possibleHits.push(new Coordinates(2, 10));
			return;
		} else if (x == 10 && y == 10) {
			possibleHits.push(new Coordinates(9, 10));
			possibleHits.push(new Coordinates(10, 9));
			return;
		} else if (x == 1) {
			possibleHits.push(new Coordinates(1, y + 1));
			possibleHits.push(new Coordinates(1, y - 1));
			possibleHits.push(new Coordinates(2, y));
			return;
		} else if (x == 10) {
			possibleHits.push(new Coordinates(10, y + 1));
			possibleHits.push(new Coordinates(10, y - 1));
			possibleHits.push(new Coordinates(9, y));
			return;
		} else if (y == 1) {
			possibleHits.push(new Coordinates(x + 1, 1));
			possibleHits.push(new Coordinates(x - 1, 1));
			possibleHits.push(new Coordinates(x, 2));
			return;
		} else if (y == 10) {
			possibleHits.push(new Coordinates(x + 1, 10));
			possibleHits.push(new Coordinates(x - 1, 10));
			possibleHits.push(new Coordinates(x, 9));
			return;
		}
		possibleHits.push(new Coordinates(x, y + 1));
		possibleHits.push(new Coordinates(x, y - 1));
		possibleHits.push(new Coordinates(x + 1, y));
		possibleHits.push(new Coordinates(x - 1, y));
	}

	Coordinates lastShot;

	public Coordinates smartShot(boolean lastHit) {
		Coordinates temp;
		if (lastHit) {
			addToStack(lastShot);
		}
		while (true) {
			if (!possibleHits.isEmpty()) {
				while (true) {
					temp = possibleHits.pop();
					if (!shotsDone[temp.getY() - 1][temp.getX() - 1]) {
						shotsDone[temp.getY() - 1][temp.getX() - 1] = true;
						lastShot = temp;
						return temp;
					}
					if (possibleHits.isEmpty()) {
						temp = randomShot();
						lastShot = temp;
						return temp;
					}
				}
			}
			temp = randomShot();
			lastShot = temp;
			return temp;
		}
	}
}