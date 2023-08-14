
enum GameCommand {
	eCmdNone, 
	eCmdRunCommandList,    // args: context, list
	eCmdGotoCell,          // args: x, y, dir
	eCmdGotoLevel,         // args: level, x, y, dir
};
