# Timed

A simple time utility library

```d
import timed : setInterval, stopInterval;

import std.stdio : writeln;
import std.datetime : seconds;
import core.thread.osthread : Thread;

void main()
{
	// "tid" of type Tid can be referenced 
	// to stop setInterval()
	auto tid = setInterval(1000, { writeln("tick"); });
	auto tid2 = setInterval(3000, { writeln("tock"); });
	Thread.sleep(12.seconds);

	// stop running setInterval()
	stopInterval(tid);
	stopInterval(tid2);
}
```
## To-do
* [x] Proper setInterval with cancellation
* [ ] setTimeout