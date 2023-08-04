
struct WoodRotConstants {
	static const int VIEWPORT_WIDTH = 240;
	static const int VIEWPORT_HEIGHT = 172;
	static const int VIEW_ROWS = 6;
	static const int VIEW_COLS = 12;
};

// Dummy AI test
managed struct WoodRotAI {
	DSM_StateRunner *Runner;
	WorldPosition *Pos;
	Overlay *Over; // representation
	
	// Action states
	WorldPosition *WalkTarget;
	int SpeakTimer;
	Overlay *OverSpeak;
	
	import static WoodRotAI *Create(DSM_StateList *list, WorldPosition *pos);
	import void Tick();
	import void Action(String action);
};

struct WoodRotGame {
	import static void DrawGrid(DrawingSurface *dest, int x, int y, int w, int h);
	import static void DrawPlayerView(DrawingSurface *dest, int x, int y, int w, int h);
	
	// fixme better names
	import static bool TryWalkAbs(WorldPosition *who, int dx, int dy);
	import static bool TryWalkLocal(WorldPosition *who, int dx, int dy);
	import static WorldDirection Turn(WorldPosition *who, bool clockwise);
	import static WorldDirection Face(WorldPosition *who, WorldDirection dir);
	import static WorldDirection FaceDeltaPos(WorldPosition *who, int dx, int dy);
	
	import static void AddAI(WoodRotAI *ai);
	import static void TickAI();
};

import WorldPosition *playerEye;
