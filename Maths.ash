///////////////////////////////////////////////////////////////////////////////
//
// Maths extensions module.
//
///////////////////////////////////////////////////////////////////////////////

// Returns absolute value
import int Abs(static Maths, int x);
// Returns max of two integers
import int Max(static Maths, int a, int b);
// Returns min of two integers
import int Min(static Maths, int a, int b);
// Returns a unit value, that is -1, 0 or 1 for a negative, zero or positive
// value respectively.
import int Sign(static Maths, int x);

// Does a random number test using certain chance to succeed;
// chance must be between 0.0 and 1.0, inclusive, where 0 always fails
// and 1.0 always succeeds.
import bool HitChance(static Maths, float chance);
