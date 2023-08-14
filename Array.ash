///////////////////////////////////////////////////////////////////////////////
//
// Generic array methods.
// 
// AGS does not support true generic functions, but it's possible to up-cast
// an object's pointer, that is - cast from the managed child struct to
// managed parent struct pointer. Curiously, AGS also can cast an array of
// child struct pointers to array of parent pointers.
// So here's a trick (or hack) that we might use for managed structs:
// - declare a dummy parent struct;
// - derive each one of the desired structs from this dummy parent;
// - now we may perform certain actions over an array of our structs, 
//   converted to array of dummy parents.
//
// Limitations: because we cannot down-cast, that is - convert back from
// parent to child struct, therefore we cannot *allocate* anything inside these
// "generic" functions. We cannot allocate new arrays, nor new objects, because
// we do not really know which type to use.
// Also, we cannot *return* arrays, since these will be parent arrays.
//
// What we are allowed to do:
// * copy and move elements;
// * assign null.
//
///////////////////////////////////////////////////////////////////////////////

// Dummy parent type of any array element
managed struct ArrayElement {
};

// Returns array's length; handles null array case.
import int Array_SafeLength(ArrayElement *arr[]);
// Search for an empty slot in array, and adds there an element;
// returns resulting index on success, and -1 on failure;
// handles null array case.
import bool Array_TryAdd(ArrayElement *arr[], ArrayElement *elem);
// Copies count src elements to dest array;
// requires that both dest and src are not null, and count is valid.
import void Array_Copy(ArrayElement *dest[], ArrayElement *src[], int count);
