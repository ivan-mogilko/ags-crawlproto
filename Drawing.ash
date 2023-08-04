
// Draws a frame (unfilled rectangle)
import function DrawFrame(this DrawingSurface*, int x1, int y1, int x2, int y2);
// Draws a quad out of two filled triangles, each with their own color;
// vertices are defined in a clockwise order
import function DrawQuadSplit(this DrawingSurface*,
	int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int color1, int color2);
