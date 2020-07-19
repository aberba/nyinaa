module nyinaa.timers;

// import std.stdio : writeln;
import core.thread.osthread : Thread;
import std.datetime.stopwatch : Duration, StopWatch, msecs;
import std.concurrency : receiveTimeout, receive, spawn, Tid, send, thisTid;

/**
* Runs a callback function at certain interval
*
* Params:
*       duration = The time interval as a duration
*       callback = callback function at every tick
*
* Example:
* ---
*       import nyinaa.timers: setInterval;
*       
*       import std.stdio : writeln;
*       import std.datetime : msecs;
*       import core.thread.osthread : Thread;

*       void main()
*       {
*           setInterval(1000.msecs, (){ writeln("tick"); });
*           setInterval(2000.msecs, (){ writeln("tock"); });
* 
*           // wait a little before exit
*           Thread.sleep(4000.msecs);
*       }
* ---
*/

Tid setInterval(Duration duration, void function() callback)
{
    static void worker(Duration d, void function() cb)
    {
        // writeln("Starting ", thisTid, "...");
        bool done = false;

        StopWatch sw;
        sw.start;
        while (true)
        {
            // wait for messages for a timespan of at least `d`
            // wait for messages for a timespan of at least `d`
            receiveTimeout(d, (string text) {
                //writeln("Received string: ", text);
                if (text == "cancel")
                    done = true;
            });

            if (done)
                break;

            // if "cancel" message is not received,
            //  check timeout for the callback
            if (sw.peek >= d)
            {
                cb();
                sw.reset;
            }
        }
    }

    Tid id = spawn(&worker, duration, callback);
    return id;
}

/**
* Cancels a setInterval() timer
*
* Params:
*       threadId = Thread id of the setInterval() timer to be cancelled
*
* Example:
* ---
*       import nyinaa.timers: setInterval, stopInterval;
*
*       import std.stdio : writeln;
*       import std.datetime : msecs;
*       import std.concurrency : Tid;
*       import core.thread.osthread : Thread;
*
*       void main()
*       {
*           Tid b = setInterval(1000.msecs, (){ writeln("Hello from spawned thread B"); });
*           // Let wait for 2 seconds
*           Thread.sleep(2000.msecs);
*
*           // cancel timer
*           stopInterval(b);
*       }
* ---
*/
void stopInterval(Tid threadId)
{
    send(threadId, "cancel");
}

/**
* Runs a callback function at certain interval
*
* Params:
*       duration = The time interval as a duration
*
* Example:
* ---
*       import nyinaa.timers: setInterval;
*
*       import std.datetime : msecs;
*       import std.concurrency : Tid;
*       import std.stdio : writeln;
*
*       void main()
*       {
*           auto b = setInterval(1000.msecs, (){ writeln("Hello from spawned thread B"); });
*           // Let this one run a little
*           Thread.sleep(2500.msecs);
*           stopInterval(b);
*       }
* ---
*/
// auto setTimeout(long milliseconds, void function() callback)
// {
//     static void worker(Duration d, void function() cb)
//     {
//         // writeln("Starting ", thisTid, "...");

//         bool done = false;

//         StopWatch sw;
//         sw.start;
//         while (true)
//         {
//             // wait for messages for a timespan of at least `d`
//             receiveTimeout(d, (string text) {
//                 //writeln("Received string: ", text);
//                 if (text == "cancel")
//                     done = true;
//             });

//             if (done)
//                 break;

//             // if "cancel" message is not received,
//             //  check timeout for the callback
//             if (sw.peek >= d)
//             {
//                 cb();
//                 done = true;
//             }

//             //sw.reset;
//         }
//     }

//     Tid id = spawn(&worker, milliseconds.msecs, callback);

//     return id;
// }

// void stopTimeout(Tid tid)
// {
//     send(tid, "cancel");
// }
