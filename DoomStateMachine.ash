/******************************************************************************
//
// SYNTAX:
//
//     STATE STATENAME
//         LOOP L F,F,F... [DELAY [ACTION [CHANCE [ARGS]]]]
//         ACTION [CHANCE [ARGS]]
//         GOTO CHANCE STATENAME
//         STOP
//
// KEYWORDS:
//  - STATE
//  - LOOP
//  - GOTO
//  - STOP
//  everything else is ACTION
//
//
******************************************************************************/


managed struct DSM_Frame {
	int Frame;
	int Delay;
};

managed struct DSM_StateStep extends ArrayElement {
	int Loop;
	DSM_Frame Frames[];
	int Delay;
	float Chance;
	String Action;
	String Args;
};

managed struct DSM_State extends ArrayElement {
	String Name;
	DSM_StateStep Steps[];

	import void AddStep(DSM_StateStep *step);
};

managed struct DSM_StateList {
	int View;
	DSM_State States[];
	
	import static DSM_StateList *CreateFromText(int view, String text);
	import DSM_State *FindState(String name);
	import int FindStateIndex(String name);
	import void AddState(DSM_State *state);
};

managed struct DSM_StateRunner {
	DSM_StateList *List;
	int State;
	int Step;
	int FrameIndex;
	int View;
	int Loop;
	int Frame;
	int Timer;
	String Action;
	String Args;
	
	import static DSM_StateRunner *Create(DSM_StateList *list);
	import String Tick();
	import bool Goto(String state);
	
	import protected void StartState();
	import protected void StartStep();
	import protected void StartFrame();
	import protected void NextState();
	import protected void NextStep();
	import protected void NextFrame();
	import protected void Stop();
	import protected void DoAction();
};
