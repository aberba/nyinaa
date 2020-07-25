/++
Nyinaa (meaning "all" or "everything" in Twi language) is an all-in-one collection of reusable functions & utilities (timers, validators, sanitizers, ranges, logging, ...)

Its goal is to provide convenience function commonly used when developing applications such a web development, desktop application and the like. Many functions are not implemented yet. If you want something that is not already available, please submit a pull request OR file an issue at https://github.com/aberba/nyinaa/issues
        
<h3> These are the categories of utilities currently being implemented.</h3>
<ul>
    <li><a href="sanitizers.html">Sanitizers</a> - for sanitizing data `stripTags()`, ...</li>
    <li><a href="validators.html">Validators</a> - for user data (e.g. form data) validation. `isEmail`, `isIp`, ...</li>
    <li><a href="timers.html">Timers</a> - Timer function. `setInterval()`, ...</li>
</ul>

+/

module nyinaa;

public import nyinaa.timers;
public import nyinaa.sanitizers;
public import nyinaa.validators;

///
unittest
{
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
}
