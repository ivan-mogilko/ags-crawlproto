
enum GameCommand {
	eCmdNone, 
	eCmdRunCommandList,    // args: context, list
	eCmdGotoCell,          // args: x, y, dir, behavior (flags)
	eCmdGotoLevel,         // args: level, x, y, dir
};
