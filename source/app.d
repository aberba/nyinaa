import nyinaa : setInterval;
import std.stdio : writeln, readf;
import std.datetime : seconds;
import core.thread.osthread : Thread, thread_joinAll;

void main()
{
	// string name = to!string(2);

	// "tid" of type Tid can be referenced
	// to stop setInterval()
	auto tid = setInterval(1.seconds, () { writeln("tick"); });
	auto tid2 = setInterval(2.seconds, () { writeln("tock"); });

	// stop running setInterval()
	// stopInterval(tid);
	// stopInterval(tid2);
	thread_joinAll();

	// use evenNumbers()
	// 	evenNumbers([1, 2, 3, 4, 5, 6]);
}
