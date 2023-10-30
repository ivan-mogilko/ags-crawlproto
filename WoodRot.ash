
struct WoodRotConstants {
	static const int VIEWPORT_WIDTH = 320;
	static const int VIEWPORT_HEIGHT = 200;
	static const int VIEW_ROWS = CELLVIEW_MAX_CELL_ROWS;
	static const int VIEW_COLS = CELLVIEW_MAX_CELL_COLS;
};

// Dummy AI test
// TODO: pick out a shared parent struct to use for all level objects, 
// that have position, animation, etc.
managed struct WoodRotAI extends ArrayElement {
	DSM_StateRunner *Runner;
	LevelObject *LObject; // representation on the level
	
	// Action states
	ObjectPosition *WalkTarget;
	
	import static WoodRotAI *Create(DSM_StateList *list, ObjectPosition *pos);
	import void Tick();
	import void Action(String action);
};

// TODO: split out a more generic Game struct with common functions
struct WoodRotGame {
	import static void DrawGrid(DrawingSurface *dest, int x, int y, int w, int h);
	import static void DrawPlayerView(DrawingSurface *dest, int x, int y, int w, int h);
	
	// fixme better names
	import static bool TryWalkAbs(ObjectPosition *who, int dx, int dy);
	import static bool TryWalkLocal(ObjectPosition *who, int dx, int dy);
	import static ObjectDirection Turn(ObjectPosition *who, bool clockwise);
	import static ObjectDirection Face(ObjectPosition *who, ObjectDirection dir);
	import static ObjectDirection FaceDeltaPos(ObjectPosition *who, int dx, int dy);
	
	import static void AddAI(WoodRotAI *ai);
	import static void TickAI();
};

import ObjectPosition *playerEye;
