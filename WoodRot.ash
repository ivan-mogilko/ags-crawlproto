
struct WoodRotConstants {
	static const int VIEWPORT_WIDTH = 240;
	static const int VIEWPORT_HEIGHT = 172;
	static const int VIEW_ROWS = 6;
	static const int VIEW_COLS = 12;
};

struct WoodRotGame {
	import static void DrawGrid(DrawingSurface *dest, int x, int y);
	import static void DrawPlayerView(DrawingSurface *dest, int x, int y);
	
	import static bool TryWalk(WorldPosition *who, int dx, int dy);
	import static WorldDirection Turn(WorldPosition *who, bool clockwise);
	import static WorldDirection Face(WorldPosition *who, WorldDirection dir);
};

import WorldPosition *playerEye;
