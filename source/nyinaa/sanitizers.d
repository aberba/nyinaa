module nyinaa.sanitizers;

/***********************************
 * strip tags from an HTML string
 * Params:
 *      input = the HTML string you want to strip tags from
 *      allowedTags = an array of tag names allow in final output
 */

string stripTags(string input, in string[] allowedTags = [])
{
    import std.regex : Captures, replaceAll, ctRegex;

    auto regex = ctRegex!(`</?(\w*)>`);

    string regexHandler(Captures!(string) match)
    {
        string insertSlash(in string tag)
        in
        {
            assert(tag.length, "Argument must contain one or more characters");
        }
        do
        {
            return tag[0 .. 1] ~ "/" ~ tag[1 .. $];
        }

        bool allowed = false;
        foreach (tag; allowedTags)
        {
            if (tag == match.hit || insertSlash(tag) == match.hit)
            {
                allowed = true;
                break;
            }
        }
        return allowed ? match.hit : "";
    }

    return input.replaceAll!(regexHandler)(regex);
}

///
unittest
{
    assert(stripTags("<html><b>bold</b></html>") == "bold");
    assert(stripTags("<html><b>bold</b></html>", ["<html>"]) == "<html>bold</html>");
}
