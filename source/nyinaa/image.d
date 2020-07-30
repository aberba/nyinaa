module nyinaa.image;

/***********************************
Checks if a string is a valid image data URI string. Currently suports JPG, PNG, GIF, WebP, SVG and BMP. 
See https://en.wikipedia.org/wiki/Data_URI_scheme

Params:
    dataURI = the base 64 string to do check on
 */

auto isImageDataURI(string dataURI)
{
    import std.algorithm : startsWith, canFind;
    import std.string : strip;
    import std.array : split;

    if (!dataURI.length)
        return false;

    immutable allowedFormats = [
        "image/png", "image/jpg", "image/jpeg", "image/webp", "image/gif",
        "image/svg", "image/bmp"
    ];

    string prefix = dataURI.split(";")[0];

    // base64 image must start with a data: prefix
    if (!prefix.startsWith("data:"))
        return false;

    string type = prefix.strip("data:").strip;
    return allowedFormats.canFind(type);
}

///
unittest
{
    assert(isImageDataURI("data:image/gif;base64,R0l"));
    assert(!isImageDataURI("datax:image/gif;base64,R0l"));
}

/**
Converts an image data URI string to an image buffer. Currently suports JPG, PNG, GIF, WebP, SVG and BMP. See https://en.wikipedia.org/wiki/Data_URI_scheme

Params:
   dataURI = the data URI string to convert to an image buffer. 
 */
auto bufferFromDataURI(string dataURI)
{
    import std.array : split;
    import std.string : strip;
    import std.base64 : Base64;
    import std.stdio : writeln;
    import std.outbuffer : OutBuffer;
    import std.algorithm : startsWith, canFind, countUntil;

    // Image data format 
    struct ImageData
    {
        // image buffer
        OutBuffer buffer;

        // image mime type
        string extension;

        //  image mime type
        string mimeType;
    }

    if (!isImageDataURI(dataURI))
        throw new Exception("Invalid image data URI");

    immutable metaData = dataURI.split(',')[0];
    string prefix = metaData.split(';')[0];

    immutable typeExtensions = [
        "image/png" : ".png", "image/jpg" : ".jpg", "image/jpeg" : "j.peg",
        "image/webp" : ".webp", "image/gif" : ".gif", "image/svg" : ".svg",
        "image/bmp" : ".bmp"
    ];

    string mimeType = prefix.strip("data:").strip;

    /// strip out meta data prefix and
    // strip out comma after "base64"
    debug writeln("metaData: ", metaData);
    debug writeln("prefix: ", prefix);
    string base64Data = dataURI.strip(metaData).strip(",");

    string extension = typeExtensions[mimeType];
    debug writeln(extension, " ", mimeType);

    ubyte[] data = Base64.decode(base64Data);
    OutBuffer buffer = new OutBuffer();
    buffer.write(data);

    return ImageData(buffer, extension, mimeType);
}

///
unittest
{
    import std : readText, writeln;

    const text = readText("./snippets/data-uri.txt");

    const result = bufferFromDataURI(text);

    // buffer is of type `OutBuffer`
    // See `std.outbuffer.OutBuffer`
    writeln(result.buffer.toBytes);

    writeln(result.mimeType);
    writeln(result.extension);
}
