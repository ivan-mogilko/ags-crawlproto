///////////////////////////////////////////////////////////////////////////////
//
// The Level module.
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
	eDirForward 	= 1, // matches North
	eDirRight		= 2, // matches East
	eDirBackward	= 3, // matches South
	eDirLeft		= 4, // matches West
};

// Position and direction of an object, in either absolute or
// local (relative) coordinate space.
managed struct ObjectPosition {
	int X, Y;
	ObjectDirection Dir;
	
	import static ObjectPosition *Create(int x, int y, ObjectDirection dir);
};

// MapTransform helps to calculate absolute map position of something
// located relatively to the object. Contains position (aka "origin" and
// directional axes of an object in the map's coordinate space.
//
// Axes point into direction in which object's POV rows or columns increase
// their index, respectively. Remember that rows go from "back" to "forth",
// and  columns go from "left" to "right" in the object's local space.
// For example, if viewRowAxisY = 1 this means that view row increases along
// the map's Y coordinate (object "faces" into positive Y direction).
// If viewRowAxisX = -1 this means that view row increases opposite to map's X
// axis (object "faces" into negative X direction).
//
// These axes could be used to calculate actual map position of a cell relative
// to this object; for example, if you want to find out map coordinates of cell
// located one step forward, one step left from the object.
// Assuming origin is object's absolute pos on map, relative cell position is
// stored in variables cellCol and cellRow, then the conversion formula is:
//
//   mapX = origin.X + cellRow * viewRowAxis.X + cellCol * viewColAxis.X;
//   mapY = origin.Y + cellRow * viewRowAxis.Y + cellCol * viewColAxis.Y;
//
managed struct MapTransform
{
	// Origin is object's absolute pos on map
	int originX, originY;
	// Tells which map direction the object's POV rows increase towards to.
	int viewRowAxisX, viewRowAxisY;
	// Tells which map direction the object's POV columns increase towards to.
	int viewColAxisX, viewColAxisY;
};

// FIXME: this is ugly, figure out how to share this with CellView... :/
// TODO: separate constants for left and right side walls, 
// may be necessary if we support "fences" between passable cells
enum TextureType {
	eTxType_Floor, 
	eTxType_Ceil, 
	eTxType_Front, 
	eTxType_Side, // side wall (left or right, depending on cell pos)
	eTxTypeNum
};

enum TextureSequenceType {
	eTxSeq_Fixed, // stay, can be changed by command
	eTxSeq_Normal, // change one by one in time
	eTxSeq_Random // change at random in time
};

managed struct TextureSequence {
	TextureSequenceType Type;
	int TexColor1[];
	int TexColor2[];
	int FrameTime;
	int Timer;
};

managed struct CellTile {
	int FloorTile;
	int FloorFrame;
	int CeilTile;
	int CeilFrame;
};

enum CommandTrigger {
	eCmdTrigger_Enter, // enter cell or pass wall
};

// Command describes a game command with arguments.
// This is a way to schedule a sequence of actions, triggered upon
// certain event.
struct Command {
	GameCommand Type;
	int Args[5];
	String SArg;
};

managed struct CellCommand {
	CommandTrigger Trigger; // trigger type
	Command Cmd;
};

// Description of the LevelObject type, 
// defines its constant or default properties and behavior.
managed struct LevelObjectClass {
	String Name;
	int View, Loop; // View and Loop, for a simple continuous animation
	// FIXME: make behavior flags
	bool Directional; // use different loops for 4 facing directions
	bool AnimateOnceAndRemove;
};

// LevelObject describes a dynamic state of a level object
managed struct LevelObject extends ArrayElement {
	LevelObjectClass Def;
	ObjectPosition Pos;
	Overlay *Over; // graphical representation
	int View, Loop, Frame; // current animation params
	int Timer; // animation timer
	
	import static LevelObject *Create(LevelObjectClass def, int x, int y, ObjectDirection dir);
	import static LevelObject *Create2(LevelObjectClass def, ObjectPosition pos);
};

//
// Level struct contains the map data, and provides methods for working with
// the map's and objects' coordinate spaces.
// 
struct Level
{
	//--------------------------------------------------------
	// Resource data
	// TODO: should store actual tilemaps for textures.
	//--------------------------------------------------------
	// Two basic colors, used for anything not in tile array
	int BasicColor1[eTxTypeNum];
	int BasicColor2[eTxTypeNum];
	// Pair of AGS colors per texture index
	int TexColor1[];
	int TexColor2[];
	// Texture sequence per texture index
	TextureSequence TexSeq[];

	// Cell object types description, to be used in this level
	// TODO: actually, may move this to some kind of a "game manager"
	LevelObjectClass LevelObjectTypes[];
	LevelObjectClass TeleportFx; // teleport fx type

	//--------------------------------------------------------
	// Map data
	// FIXME: make most of this writeprotected?
	//--------------------------------------------------------
	// Map size in cells
    int MapWidth;
    int MapHeight;
	// Map layers, expandable
	// each layer must be (MapWidth * MapHeight) size
	//
	// 8-bit passability mask;
	//    0  = unrestricted, 
	//    1+ = passable only if player has the same bits set
	char CellPassable[];
	// Cell tiles (textures) definition
	CellTile CellTiles[];
	// Command triggered by each cell
	CellCommand CellTriggers[];

	// Separate level objects, not directly bound to the number of tiles
	LevelObject LevelObjects[];

	// Converts a position relative to the given object into the absolute map coordinates.
    import static Point *ObjectToMap(ObjectPosition *who, int x, int y);
	// Converts an absolute map position to a position relative to the given object.
	import static Point *MapToObject(ObjectPosition *who, int x, int y);
	// Converts a relative offset from object's to map coordinates
	import static Point *ObjectDeltaToMap(ObjectPosition *who, int x, int y);
	// Converts a relative offset from map to object's coordinates
	import static Point *MapDeltaToObject(ObjectPosition *who, int x, int y);
	// Converts an absolute direction into the object's relative dir;
	// in other words - where the dir is facing when looking from the "who" perspective.
	// Here "forward" is North, "left" is West, "right" is East, "back" is South. 
	import static ObjectDirection MapToObjectDir(ObjectPosition *who, ObjectDirection dir);
	// Converts ObjectDirection into the AGS Direction, which also corresponds
	// to the directional loop index.
	import static Direction DirToAGSLoop(ObjectDirection dir);

	// Returns position and directional axes of an object translated to map coordinate space.
	// See comment to MapTransform struct for more information.
    import static MapTransform *GetObjectToMapTransform(ObjectPosition* who);

	import static void AddObject(LevelObject *obj);
	import static LevelObject AddObject2(LevelObjectClass *def, int x, int y, ObjectDirection dir);
	import static void RemoveObject(LevelObject *obj);
	import static void RemoveObject2(int index);
	import static void Tick();
	
	import static void Trigger(ObjectPosition *who, int from_x, int from_y, CommandTrigger trigger);
	import static void RunCommand(ObjectPosition *who, GameCommand type,
		int arg1, int arg2, int arg3, int arg4, int arg5, String sarg);
};

// Current level
import Level CLevel;
