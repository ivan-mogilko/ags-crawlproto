// TODO: rewrite / adjust following large commentary, as the
// data representation was changed for this project!!

// TODO: explain and give image of a single cell and its walls

// CellViewSchema describes location of drawn tiles on screen, in screen coordinates.
// 
// Let's assume the player's "eye" can see number of map cells around itself,
// then we think of the cells's distance along the forward axis as of VIEW ROW
// and cell's distance along the side axis as of VIEW COLUMN.
// View rows begin at 0 and go up, view columns originate at 0 and go down and up
// (left and right) symmetrically. Player's eye is at 0,0.
// E.g.:
//                  cols
//            -2 -1  0  +1 +2
//        3    x  x  x  x  x
//   rows 2    x  x  x  x  x
//        1    x  x  x  x  x
//        0       x  x  x
//                   ^
//                   E
//
//
// Particular VIEW ROW and VIEW COLUMN give us a VIEW CELL.
// For each visible cell the schema defines a screen rectangle of every possible part
// of the map object: front wall, side walls, floor and ceiling.
// "Front wall" is the one facing player, "back wall" is the far wall of the cell
// (latter may be ignored if your game does not feature transparent walls),
// left and right walls are cell's side walls that are further to left or to right
// from cell's center, relative to how player sees the cell.
// Note that for side columns you may define only one of the side walls (again, this
// depends on whether you feature transparent walls).
// E.g.:
//              _ ........ ........ ........ _
//          _ -__|______ /|________|\ ______|__- _
//         |     |......|.|........|.|......|     |
//         |  _ -       | /        \ |       - _  |
//         |-___________|/__________\|___________-|
//
//               -1           0            +1
//
// Here cell at 0 should have at least: front wall, floor and ceiling defined.
// Cell at -1 should have front wall and right wall defined (+ floor & ceiling)
// and cell at +1 needs front wall and left wall defined (+ floor & ceiling).
// Other walls are optional.
//
// More tile definitions could be added if necessary (if their positions cannot be
// easily derived from ones above).
//

// Cell rows and columns limits
#define CELLVIEW_MAX_CELL_ROWS      (5)
#define CELLVIEW_MAX_CELL_COLS      (11)
#define CELLVIEW_MAX_CELL_SPACE     (CELLVIEW_MAX_ROWS * CELLVIEW_MAX_COLS)
// Cell vertixes limits
#define CELLVIEW_MAX_VX_ROWS        (CELLVIEW_MAX_CELL_ROWS + 1)
#define CELLVIEW_MAX_VX_COLS        (CELLVIEW_MAX_CELL_COLS + 1)

// TODO: separate constants for left and right side walls, 
// may be necessary if we support "fences" between passable cells
enum CellViewTile {
	eCVTile_Floor, 
	eCVTile_Ceil, 
	eCVTile_Front, 
	eCVTile_Side,    // side wall (left or right, depending on cell pos)
	eCVTile_Object,  // placeholder for "any object in cell"
	eCVTileNum
};

// Vertex positions!!
struct CellViewStrip {
	int Y1, Y2;
	int X[CELLVIEW_MAX_VX_COLS];
};


struct CellViewSchema {
	writeprotected int Width;    // viewport width
	writeprotected int Height;   // viewport height
	writeprotected int CellRowCount; // number of near->far cells
	writeprotected int CellColCount; // number of left->right cells
	writeprotected int CellColMiddle; // middle cell column
	writeprotected int VxRowCount; // number of near->far grid lines
	writeprotected int VxColCount; // number of left->right grid lines

	// scale down factors for entities (items, objects and mobs)
	writeprotected float BaseScale;  // scale factor at the starting cell
	writeprotected float RowScaling; // scale factor, applied per each row of cells
	writeprotected float ColScaling; // scale factor, applied per each column of cells

	// These are vertex (grid) positions!!
	writeprotected CellViewStrip Strips[CELLVIEW_MAX_VX_ROWS];
	writeprotected float CellScaling[CELLVIEW_MAX_CELL_ROWS, CELLVIEW_MAX_CELL_COLS];

	// Setup basic schema properties
	import void SetView(int width, int height, int row_count, int col_count);
	// Generate x-uniform strip
	import void SetUniformStrip(int row, int y1, int y2, int x_start, int u_width);
	//
	import void SetScaling(float base_scale, float row_scale, float col_scale);
	// Converts a relative position in object's local space to the
	// cell view's row/cell pair
	import Point *ObjectToCellView(int objx, int objy);
};

// Current grid view schema setup
import CellViewSchema CV_Schema;

// FirstPersonView class draws a pseudo-3D first person view of a map as if visible
// from the player's eyes.
struct FirstPersonView {
	//
	// Configuration
	//
	// Tells to draw walls half-height, helps testing level actors
	import static void SetHalfWallMode(bool half_wall);

	//
	//
	// Methods for drawing the first person view on a drawing surface
	//
	// Draws a rectangle around viewport
	import static void DrawViewport(DrawingSurface* ds, int color);
	// Draws a grid frame for testing purposes
	import static void DrawGridFrame(DrawingSurface* ds, int cell_color, int wall_color);
	// Draws current view as seen from the given pos into given direction
	import static void DrawLocation(DrawingSurface *ds, ObjectPosition *eye);
	// Draws particular map cell in viewport
	import static void DrawCell(DrawingSurface *ds, ObjectPosition *eye,
		int mapx, int mapy, int row, int col);

	//
	// Methods for constructing the first person view using room overlays
	//
	// Sets camera offset to add when constructing a scene using overlays
	import static void SetCameraOffset(int camx, int camy);
	import static void ConstructLocation(ObjectPosition *eye);
	import static void ConstructCell(ObjectPosition *eye, int mapx, int mapy, int row, int col);
	// Arranges the object (represented by overlay) in the first person view
	import static void ConstructObject(ObjectPosition *eye, ObjectPosition *obj,
		int view, int loop, int frame, Overlay *over);

	import protected static void ResetTileCache();
	import protected static void DisplayWallTile(int row, int col, CellViewTile tile);
	import protected static void HideWallTile(int row, int col, CellViewTile tile);
	import protected static void CreateWallSprite(int row, int col, CellViewTile tile);
	import protected static void CreateWallTile(int row, int col, CellViewTile tile);
	import protected static int  CalcZorder(int row, int col, CellViewTile tile);
};
