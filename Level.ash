///////////////////////////////////////////////////////////////////////////////
//
// This module defines a game Level, that is a 2D map of cells, where player 
// and NPCs may walk around and engage in a number of activities.
//
// Besides storing a level cell data, the module provides a number of methods
// for converting between map and local object coordinate systems.
//
// The absolute map coordinate system corresponds to the level's grid of cells.
// The map is a 2D grid which goes (0, 0) -> ((Width-1), (Height-1)).
// The direction on this map is fixed:
//  - North    -> towards -Y (or Y = 0)
//  - East     -> towards +X (or X = Width)
//  - South    -> towards +Y (or Y = Height)
//  - West     -> towards -X (or X = 0)
//
// The local coordinate system corresponds to the particular object's
// perspective. In this local system the owner object is always a center of
// coordinates (0, 0), Y axis points "forward" from this object, and X axis
// points to the "right" from this object. Hence the direction in this system
// is defined like:
//  - Forward  -> towards +Y
//  - Right    -> towards +X
//  - Backward -> towards -Y
//  - Left     -> towards -X
//
// The local coordinate systems are used to find out relative positions of
// objects and cells when building first person's view, or working with
// NPCs AI, for instance.
//
//-----------------------------------------------------------------------------
//
// Example:
//
// The map is (0, 0) -> (9, 9), and a object A is positioned at map coordinates
// (4, 4) facing East (+X). There's another object B at map coordinates (5, 6)
// facing North (-Y), and object C at map coordinates (1, 2) facing West (-Y):
//
//                |N|
//  -  0  1  2  3  4  5  6  +X
//  0
//  1     
//  2    <C
//  3
//  4              A>
//  5
//  6                 B^
// +Y
//
// If we look from the object A's perspective, object B would be positioned at
// the local coordinates (+2, +1), that is - 1 step forward and 2 steps to the
// right, facing Left, while object C would be positioned at the local coords
// (-2, -3), that is - 2 steps left and 3 steps back, facing backwards.
//
//                    |F|
// +4
// +3
// +2
// +1                         <B
//     -4  -3  -2  -1  A^ +1  +2  +3  +4
// -1
// -2
// -3          vC
// -4
//
///////////////////////////////////////////////////////////////////////////////

// ObjectDirection depicts either an absolute direction of look or move
// on a 2D map, or a relative direction in object's local coordinate space.
// Assuming a 2D grid which goes from 0, 0 -> Width, Height, the absolute
// ObjectDirection points as:
//  - North    -> towards -Y (or Y = 0)
//  - East     -> towards +X (or X = Width)
//  - South    -> towards +Y (or Y = Height)
//  - West     -> towards -X (or X = 0)
// Relative ObjectDirection points as:
//  - Forward  -> towards +Y
//  - Right    -> towards +X
//  - Backward -> towards -Y
//  - Left     -> towards -X
// FIXME: make 0-based, need to adjust few algorithms
enum ObjectDirection {
	eDirNorth		= 1, 
	eDirEast		= 2, 
	eDirSouth		= 3, 
	eDirWest  		= 4, 
	eDirForward 	= 1, 
	eDirRight		= 2, 
	eDirBackward	= 3, 
	eDirLeft		= 4,
};

// Position and direction of an object, in either absolute or
// local (relative) coordinate space.
managed struct ObjectPosition {
	int X, Y;
	ObjectDirection Dir;
	
	import static ObjectPosition *Create(int x, int y, ObjectDirection dir);
};

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

//

struct Level
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
    import static Point *ObjectToMap(ObjectPosition *who, Point *pt);
	// Converts an absolute map position to a position relative to the given object.
	import static Point *MapToObject(ObjectPosition *who, Point *pt);
	// Converts a relative offset from object's to map coordinates
	import static Point *ObjectDeltaToMap(ObjectPosition *who, Point *pt);
	// Converts a relative offset from map to object's coordinates
	import static Point *MapDeltaToObject(ObjectPosition *who, Point *pt);
	// Converts an absolute direction into the object's relative dir;
	// in other words - where the dir is facing when looking from the "who" perspective.
	// Here "forward" is North, "left" is West, "right" is East, "back" is South. 
	import static ObjectDirection MapToObjectDir(ObjectPosition *who, ObjectDirection dir);
	//
	import static Direction WorldDirToAGSLoop(ObjectDirection dir);

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
    import static MapTransform *GetObjectToMapTransform(ObjectPosition* who);
};

import Level CLevel;
