
// Helps to calculate absolute map pos of something
// located relatively to the object;
// see explanation for GetObjectToMapTransform below.
managed struct MapTransform
{
	// Origin is object's absolute pos on map
	int originX, originY;
	//
	int viewRowAxisX, viewRowAxisY;
	int viewColAxisX, viewColAxisY;
};

// TODO: explain Map and Object coordinate spaces.
// Map coords go from 0, 0 -> Width, Height.
// WorldDirections point as:
//  - North -> towards -Y (or Y = 0)
//  - East  -> towards +X (or X = Width)
//  - South -> towards +Y (or Y = Height
//  - West  -> towards -X (or X = 0)
//

struct Location
{
	// Map data
    int MapWidth;
    int MapHeight;
	// Map layers, expandable
	//
	// 8-bit passability mask;
	//    0  = unrestricted, 
	//    1+ = passable only if player has the same bits set
	char CellPassable[];

	// TODO: accept separate x, y as params for convenience
	// Converts a position relative to the given object into the absolute map coordinates.
    import static Point *ObjectToMap(WorldPosition *who, Point *pt);
	// Converts an absolute map position to a position relative to the given object.
	import static Point *MapToObject(WorldPosition *who, Point *pt);
	// Converts a relative offset from object's to map coordinates
	import static Point *ObjectDeltaToMap(WorldPosition *who, Point *pt);
	// Converts a relative offset from map to object's coordinates
	import static Point *MapDeltaToObject(WorldPosition *who, Point *pt);
	// Converts an absolute direction into the object's relative dir;
	// in other words - where the dir is facing when looking from the "who" perspective.
	// Here "forward" is North, "left" is West, "right" is East, "back" is South. 
	import static WorldDirection MapToObjectDir(WorldPosition *who, WorldDirection dir);
	//
	import static Direction WorldDirToAGSLoop(WorldDirection dir);

	// Returns position and directional axes of an object translated to map coordinate space.
	//
	// Axes point into direction in which view rows or columns increase their index.
	// For instance, if viewRowAxisY = 1 this means that view row increases along with
	// the map's Y coordinate (object looks towards positive Y direction).
	// If viewRowAxisX = -1 this means that view row increases opposite to map's X
	// coordinate (object looks towards negative X direction).
	//
	// These axes could be used to calculate actual map position of a cell relative
	// to this object; for example, if you want to find out map coordinates of cell located
	// one step forward, one step left from the object.
	// Assuming origin is object's absolute pos on map, relative cell position is stored
	// in variable cellPos, column is cellPos.Col and row is cellPos.Row,
	// then the conversion formula is:
	//
	//   mapX = origin.X + cellPos.Row * viewRowAxis.X + cellPos.Col * viewColAxis.X;
	//   mapY = origin.Y + cellPos.Row * viewRowAxis.Y + cellPos.Col * viewColAxis.Y;
	//
    import static MapTransform *GetObjectToMapTransform(WorldPosition* who);
};

import Location CLevel;
