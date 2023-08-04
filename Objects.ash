
// Absolute world direction
enum WorldDirection {
	eDirNorth, 
	eDirEast, 
	eDirSouth, 
	eDirWest
};

// Absolute position and direction of an object
managed struct WorldPosition {
	int X, Y;
	WorldDirection Dir;
};
