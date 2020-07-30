/**
    Handy functions for use in range related tasks
*/

module nyinaa.range;

/***********************************
 * creates a concrete range (std.container.array.Array range) out of an eager range that can for example be used with `std.range.sort()` without requiring ``.array()` in the chain. This helps avoid allocating extra garbage on the heap as in the case of `.array()`. So it's perfect for temporal arrays in chained pipelining.
    
    Credit to Steven Schveighoffer for the tip at https://forum.dlang.org/post/rfk5j3$lpo$1@digitalmars.com

Params:
     r = the eager range to be processed 

Example:
---
     
    /++
        Suppose I have the an array which is mapped with a function `doSomething()`
        as a predicate that does a lot of processing on each element
        you want to use `sort()` after the mapping, and there are more operations 
        done to the range after sort:
    +/
    auto arr = [20, 30, 40,50];
    arr.map!doSomething.sort(...)...;

    // `sort()` fails because the range it receives doesn't support element swapping. 
    // This might be resolved by calling `array()`:
    arr.map!doSomething.array.sort. ...;

    /++ 
        However, `array()` triggers an allocation which might not be 
        the desired behavior you want.
        `concreteRange` can be used to resolved the issue.
        Its creates a temporary array without allocating extra 
        garbage on the heap.
    +/
    arr.map!doSomething.concreteRange.sort(...)...;
---
 */
auto concreteRange(Range)(Range r)
{
    import std.range : ElementType;
    import std.container.array : Array;

    // Slicing the Array with `[]` will keep the reference count correctly, and 
    // destroy the memory automatically after you're done using it. 
    return Array!(ElementType!Range)(r)[];
}


/**
    use for two values of the same type (integer, string, struct, etc) and a custom comparison function, `cmpFunc`. If `cmpFunc` passes it returns `value` else returns `fallback`.

Params:
    value = the first value used in comparison function
    fallback = fallback value to returned when first fails the comparison
*/

T orElse(T, alias cmpFunc)(T value, T fallback)
{
    return cmpFunc(value) ? value : fallback;
}

//
unittest
{
    alias compareFunc = (a) => a == 1; // do  some computation

    int num = 0;
    assert(num.orElse!(int, compareFunc)(1) == 1); 

    alias compareFunc2 = (a) => a == "yes";

    string data = "no"; // do some processing
    assert(data.orElse!(string, compareFunc2)("yes") == "yes");
}

/** alias for .then which is useful for range concatenation
 * Example:
---
auto triples=recurrence!"a[n-1]+1"(1.BigInt)
    .then!(z=>iota(1,z+1).then!(x=>iota(x,z+1).map!(y=>(x,y,z))))
    .filter!((x,y,z)=>x^^2+y^^2==z^^2);
triples.each!((x,y,z){ writeln(x," ",y," ",z); });
---
 */
alias then(alias a) = (r) => map!a(r).joiner;
