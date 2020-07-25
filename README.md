# Nyinaa

A collection of reusable functions & utilities (timers, validators, sanitizers, ranges, logging, ...)

```d
import nyinaa.timers : setInterval, stopInterval;

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

	// OR keep running timers
	// using import core.thread.osthread: thread_joinAll;
    // thread_joinAll();
}
```
## Collections
These are the categories of utilities currently being implemented

* Sanitizers - for sanitizing data, `stripTags()`, ...
* Validators - for user data (e.g. form data) validation, `isEmail`, `isIp`, `isIpv4`, `isIpv6`, ...
* Timers - time utility function, `setInterval()`, ...

### To-do
Any generic validator form validation, etc. is welcomed

