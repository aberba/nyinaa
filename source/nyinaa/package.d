/++
Nyinaa (meaning "all" or "everything" in Twi language) is an all-in-one collection of reusable functions & utilities (timers, validators, sanitizers, ranges, logging, ...)

Its goal is to provide convenience function commonly used when developing applications such a web development, desktop application and the like. Many functions are not implemented yet. If you want something that is not already available, please submit a pull request OR file an issue at https://github.com/aberba/nyinaa/issues
+/

module nyinaa;

public import nyinaa.timers;
public import nyinaa.sanitizers;
public import nyinaa.validators;

///
unittest
{
    import nyinaa : setInterval;
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
}
