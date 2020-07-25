# Nyinaa

A collection of reusable functions & utilities (timers, validators, sanitizers, ranges, logging, ...)

### Installation
To install this package from the [Dub package repository](https://code.dlang.org), you may add `nyinaa` as dependency in your `dub.json` file and the package will be downloaded automatically during project build if it's not downloaded already.

```json
{
    "dependencies": {
        "nyinaa": "~>0.0.3"
    }
}
```

You may also fetch the latest version manually in the command-line:

```sh
dub fetch nyinaa
```

### Example

```d
import nyinaa.timers : setInterval, stopInterval;

import std.stdio : writeln;
import std.datetime : seconds;
import core.thread.osthread : Thread;

void main()
{
	// "tid" of type Tid can be referenced 
	// to stop setInterval()
	auto tid = setInterval(1000.seconds, { writeln("tick"); });
	auto tid2 = setInterval(3000.seconds, { writeln("tock"); });
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

### Documentation
See the [documentation](https://nyinaa.dpldocs.info/nyinaa.html) for the various functions and examples on how to use them.

### To-do
Any generic validator form validation, etc. is welcomed

