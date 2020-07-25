module nyinaa.validators;

import std.regex : matchFirst, ctRegex;

/**
* Checks whether a string has an email address format
* 
* Params:
*      email = the email address to do check on
*/
bool isEmail(string email)
{
    auto ctr = ctRegex!r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";

    return email.matchFirst(ctr).length == 1;
}

///
unittest
{
    assert(isEmail("hello@example.com"));
    assert(!isEmail("nah!"));
}

/**
* Checks whether a string has an IP address format (both IPv4 and IPv6)
* 
* Params:
*      ip = the IP address to do check on
*/
bool isIP(string ip)
{
    return isIPv4(ip) || isIPv6(ip);
}

///
unittest
{
    assert(isIP("192.169.0.0"));
    assert(isIP("2001:db8:0:1:1:1:1:1"));
    assert(!isIP("192.169.0.500"));
    assert(!isIP("2001:db8:0:1:1:1:1:1xxx"));
}

/**
* Checks whether a string has an IPv4 address format 
* 
* Params:
*      ip = the IPv4 address to do check on
*/
bool isIPv4(string ip)
{
    auto ctr = ctRegex!(
            `^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$`);
    return ip.matchFirst(ctr).length == 1;
}

///
unittest
{
    assert(isIPv4("127.0.0.1"));
    assert(!isIPv4("127.0.0.500"));
}

/**
* Checks whether a string has an IPv6 address format 
* 
* Params:
*      ip = the IPv6 address to do check on
*/
bool isIPv6(string ip)
{
    import std : canFind, split, asUpperCase, to;

    auto ctr = ctRegex!(`^[0-9A-F]{1,4}$`);

    // initial or final ::
    if (ip == "::")
        return true;

    // ipv6 addresses could have scoped architecture
    // according to https://tools.ietf.org/html/rfc4007#section-11
    if (ip.canFind("%"))
    {
        string[2] addressAndZone = ip.split("%");

        // it must be just two parts
        if (addressAndZone.length != 2)
            return false;

        // the first part must be the address
        if (!addressAndZone[0].canFind(':'))
            return false;

        // the second part must not be empty
        if (addressAndZone[1] == "")
            return false;
    }

    // At least some OS accept the last 32 bits of an IPv6 address
    // (i.e. 2 of the blocks) in IPv4 notation, and RFC 3493 says
    // that '::ffff:a.b.c.d' is valid for IPv4-mapped IPv6 addresses,
    // and '::a.b.c.d' is deprecated, but also valid.
    immutable foundIPv4TransitionBlock = isIPv4(ip[0 .. $ - 1]);
    immutable expectedNumberOfBlocks = foundIPv4TransitionBlock ? 7 : 8;

    // expects at most 8 blocks
    string[] blocks = ip.split(":");
    if (blocks.length > expectedNumberOfBlocks)
        return false;

    bool foundOmissionBlock = false; // marker to indicate ::

    // has :: at start of ip
    if (ip[0 .. 2] == "::")
    {
        blocks = blocks[0 .. 2];
        foundOmissionBlock = true;
    }
    else if (ip[$ - 2 .. $] == "::")
    {
        // has :: at end of ip
        blocks = blocks[$ - 2 .. $];
        foundOmissionBlock = true;
    }

    foreach (i, blk; blocks)
    {
        // test for a :: which can not be at the start/end of ip
        // since those cases have been handled above
        if (blk == "" && i > 0 && i < (blocks.length - 1))
        {
            if (foundOmissionBlock)
            {
                continue; // multiple :: in address
            }

            foundOmissionBlock = true;
        }

        if (!blk.asUpperCase.to!string.matchFirst(ctr).length == 1)
            return false;

    }

    if (foundOmissionBlock)
        return blocks.length >= 1;

    return blocks.length == expectedNumberOfBlocks;
}

///
unittest
{
    assert(isIPv6("2001:db8:0:1:1:1:1:1"));
    assert(!isIPv6("2001:db8:0:1:1:1:1:1xxx"));
}

//  3: //i,
//   4: //i,
//   5: //i,
//   all: /^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$/i
// 

/**
* Checks whether a string has a UUID version 3 format 
* 
* Params:
*      uuid = the UUID string to do check on
*/
bool isUUIDv3(string uuid)
{
    import std : asUpperCase, to;

    auto ctr = ctRegex!(`^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$`);
    return uuid.asUpperCase.to!string.matchFirst(ctr).length == 1;
}

///
unittest
{
    assert(isUUIDv3("a3bb189e-8bf9-3888-9912-ace4e6543002"));
    assert(!isUUIDv3("a3bb189e-8bf9-3888-9912-ace4e6543002-123"));
}

/**
* Checks whether a string has a UUID version 4 format 
* 
* Params:
*      uuid = the UUID string to do check on
*/
bool isUUIDv4(string uuid)
{
    import std : asUpperCase, to;

    auto ctr = ctRegex!(`^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$`);
    return uuid.asUpperCase.to!string.matchFirst(ctr).length == 1;
}

///
unittest
{
    assert(isUUIDv4("35432af0-214a-43c3-a667-42a79392eea0"));
    assert(!isUUIDv4("35432af0-214a-43c3-a667-42a79392eea0-123"));
}

/**
* Checks whether a string has a UUID version 5 format 
* 
* Params:
*      uuid = the UUID string to do check on
*/
bool isUUIDv5(string uuid)
{
    import std : asUpperCase, to;

    auto ctr = ctRegex!(`^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$`);
    return uuid.asUpperCase.to!string.matchFirst(ctr).length == 1;
}

///
unittest
{
    assert(isUUIDv5("a6edc906-2f9f-5fb2-a373-efac406f0ef2"));
    assert(!isUUIDv5("a6edc906-2f9f-5fb2-a373-efac406f0ef2-123"));
}

/**
* Checks whether a string has a UUID format. Matches any UUID format.
* 
* Params:
*      uuid = the UUID string to do check on
*/
bool isUUID(string uuid)
{
    import std : asUpperCase, to;

    auto ctr = ctRegex!(`^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$`);
    return uuid.asUpperCase.to!string.matchFirst(ctr).length == 1;
}

///
unittest
{
    assert(isUUID("35432af0-214a-43c3-a667-42a79392eea0"));
    assert(isUUID("a6edc906-2f9f-5fb2-a373-efac406f0ef2"));
    assert(isUUID("a6edc906-2f9f-5fb2-a373-efac406f0ef2"));

    assert(!isUUID("35432af0-214a-43c3-a667-42a79392eea0-123"));
    assert(!isUUID("a6edc906-2f9f-5fb2-a373-efac406f0ef2-123"));
    assert(!isUUID("a6edc906-2f9f-5fb2-a373-efac406f0ef2-123"));
}
